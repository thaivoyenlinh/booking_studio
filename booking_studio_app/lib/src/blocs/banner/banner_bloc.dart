// import 'package:booking_app/src/blocs/banner/banner_event.dart';
// import 'package:booking_app/src/blocs/banner/banner_state.dart';
// import 'package:booking_app/src/repositories/customer/banner_repo.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class BannersBloc extends Bloc<BannerEvent, BannerState> {
//   final BannerRepository _bannerRepository;

//   BannersBloc(this._bannerRepository) : super(BannerLoadingState()) {
//     on<LoadBannerEvent>((event, emit) async {
//       emit(BannerLoadingState());
//       try{
//         final banners = await _bannerRepository.getBanner();
//         emit(BannerLoadedState(banners));
//       }catch(e){
//         emit(BannerErrorState(e.toString()));
//       }
//     });
//   }
// }