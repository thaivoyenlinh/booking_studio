// import 'package:booking_app/src/models/customer/banner.model.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// import '../repositories/customer/banner_repo.dart';

// class BannerController extends GetxController{
//   var box = GetStorage();
//   var isLoading = false;
//   List<BannerModel> bannerData = [];
//   // static BannerController instance = Get.find();
//   // RxList<BannerModel> bannerList = List<BannerModel>.empty(growable: true).obs;
//   // RxBool isBannerLoading = false.obs;

//   @override
//   void onInit() {
//     getBanners();
//     if(box.read('bannerData') != null){
//       bannerData.assignAll(box.read('bannerData'));
//     }
//     super.onInit();
//   }

//   void getBanners() async{
//     try{
//       isLoading = true;
//       update();

//       List<BannerModel> _data = await BannerRepository().getBanner();
//       if(_data != null){
//         bannerData.assignAll(_data);
//         box.write('bannerData', _data);
//       }
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }
// }