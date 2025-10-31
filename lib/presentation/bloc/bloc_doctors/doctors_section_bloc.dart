import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  List<DoctorsProfileModel> allDoctors = [];
  // Pending filter criteria to apply after initial fetch completes
  double? _pendingMinPrice;
  double? _pendingMaxPrice;
  int? _pendingMinExperience;
  String? _pendingGender;

  DoctorBloc() : super(DoctorInitialState()) {
    on<FetchDoctorsEvent>(_onFetchDoctors);
    on<SearchDoctorsEvent>(_onSearchDoctors);
    on<FilterDoctorsEvent>(_onFilterDoctors);
  }

  void _onFetchDoctors(
    FetchDoctorsEvent event,
    Emitter<DoctorState> emit,
  ) async {
    emit(DoctorLoadingState());

    try {
      final doctorStream = fetchDoctors();
      await emit.forEach(
        doctorStream,
        onData: (List<DoctorsProfileModel> doctors) {
          print('📥 Fetched doctors: ${doctors.length}');
          allDoctors = doctors;
          // If a pending filter exists, apply it immediately
          if (_pendingMinPrice != null ||
              _pendingMaxPrice != null ||
              _pendingMinExperience != null ||
              (_pendingGender != null && _pendingGender!.trim().isNotEmpty)) {
            print('➡️ Applying pending filter after fetch');
            final filtered = _applyFilter(
              source: allDoctors,
              minPrice: _pendingMinPrice,
              maxPrice: _pendingMaxPrice,
              minExperience: _pendingMinExperience,
              gender: _pendingGender,
            );
            print('✅ Filtered (post-fetch) count: ${filtered.length}');
            // Clear pending once applied
            _pendingMinPrice = null;
            _pendingMaxPrice = null;
            _pendingMinExperience = null;
            _pendingGender = null;
            return DoctorLoadedState(filtered);
          }
          return DoctorLoadedState(doctors);
        },
        onError: (error, stackTrace) {
          return DoctorErrorState(error.toString());
        },
      );
    } catch (e) {
      emit(DoctorErrorState(e.toString()));
    }
  }

  // void _onSearchDoctors(
  //   SearchDoctorsEvent event,
  //   Emitter<DoctorState> emit,
  // ) {
  //   if (event.query.isEmpty) {
  //     emit(DoctorLoadedState(allDoctors));
  //     return;
  //   }

  //   final query = event.query.toLowerCase();
  //   final filtered = allDoctors.where((doc) {
  //     return doc.fullName.toLowerCase().contains(query) ||
  //         doc.department.toLowerCase().contains(query) ||
  //         doc.specialization.toLowerCase().contains(query);
  //   }).toList();

  //   emit(DoctorLoadedState(filtered));
  // }
  void _onSearchDoctors(SearchDoctorsEvent event, Emitter<DoctorState> emit) {
    print('🔍 Search query: "${event.query}"');
    print('AllDoctors count: ${allDoctors.length}');
    if (event.query.isEmpty) {
      emit(DoctorLoadedState(allDoctors));
      return;
    }
    if (allDoctors.isEmpty) {
      print('⚠️ AllDoctors is empty, fetching first...');
      emit(DoctorLoadingState());
      add(FetchDoctorsEvent());
      return;
    }
    final query = event.query.toLowerCase();
    final filtered =
        allDoctors.where((doc) {
          final nameMatch = doc.fullName.toLowerCase().contains(query);
          final deptMatch = doc.department.toLowerCase().contains(query);
          final specMatch = doc.specialization.toLowerCase().contains(query);
          return nameMatch || deptMatch || specMatch;
        }).toList();
    print('✅ Filtered results count: ${filtered.length}');
    emit(DoctorLoadedState(filtered));
  }

  void _onFilterDoctors(FilterDoctorsEvent event, Emitter<DoctorState> emit) {
    print(
      '🎯 Filtering doctors: Price ${event.minPrice}-${event.maxPrice}, '
      'Experience: ${event.minExperience}, Gender: ${event.gender}',
    );
    print('📊 Total doctors: ${allDoctors.length}');

    // 🔧 FIX: If allDoctors is empty, fetch doctors first
    if (allDoctors.isEmpty) {
      print('⚠️ AllDoctors is empty, fetching doctors first...');
      // Save pending filters to apply after fetch completes
      _pendingMinPrice = event.minPrice;
      _pendingMaxPrice = event.maxPrice;
      _pendingMinExperience = event.minExperience;
      _pendingGender = event.gender;
      emit(DoctorLoadingState());
      add(FetchDoctorsEvent());
      return;
    }

    final filtered = _applyFilter(
      source: allDoctors,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      minExperience: event.minExperience,
      gender: event.gender,
    );
    print('✅ Filtered doctors count: ${filtered.length}');
    emit(DoctorLoadedState(filtered));
  }

  // Helper: apply filter rules with debug
  List<DoctorsProfileModel> _applyFilter({
    required List<DoctorsProfileModel> source,
    double? minPrice,
    double? maxPrice,
    int? minExperience,
    String? gender,
  }) {
    var filtered = List<DoctorsProfileModel>.from(source);
    // Price
    if (minPrice != null && maxPrice != null) {
      print('🔎 Applying price filter: $minPrice - $maxPrice');
      filtered =
          filtered.where((doc) {
            final fee = doc.expectedConsultationFee.toDouble();
            return fee >= minPrice && fee <= maxPrice;
          }).toList();
    }
    // Experience
    if (minExperience != null) {
      print('🔎 Applying experience filter: $minExperience+');
      filtered =
          filtered
              .where((doc) => doc.yearsOfExperience >= minExperience)
              .toList();
    }
    // Gender
    if (gender != null && gender.trim().isNotEmpty) {
      final g = gender.trim().toLowerCase();
      print('🔎 Applying gender filter: $g');
      filtered =
          filtered
              .where((doc) => doc.gender.trim().toLowerCase() == g)
              .toList();
    }
    return filtered;
  }
}
