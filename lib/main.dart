import 'package:admin_app/bloc/authentication/authentication_bloc.dart';
import 'package:admin_app/bloc/delivery/delivery_bloc.dart';
import 'package:admin_app/bloc/message/message_bloc.dart';
import 'package:admin_app/bloc/order/order_bloc.dart';
import 'package:admin_app/bloc/product/product_bloc.dart';
import 'package:admin_app/bloc/register/register_bloc.dart';
import 'package:admin_app/bloc/report/reports_bloc.dart';
import 'package:admin_app/bloc/settings/settings_bloc.dart';
import 'package:admin_app/bloc/store/store_bloc.dart';
import 'package:admin_app/repository/address/address_repository.dart';
import 'package:admin_app/repository/address/address_repository_impl.dart';
import 'package:admin_app/repository/admin_settings_repository.dart';
import 'package:admin_app/repository/chat_room/chat_room_repository.dart';
import 'package:admin_app/repository/chat_room/chat_room_repository_impl.dart';
import 'package:admin_app/repository/delivery_repository.dart';
import 'package:admin_app/repository/message/message_repository.dart';
import 'package:admin_app/repository/message/message_repository_impl.dart';
import 'package:admin_app/repository/order/order_repository.dart';
import 'package:admin_app/repository/order/order_repository_impl.dart';
import 'package:admin_app/repository/product/product_category_repository.dart';
import 'package:admin_app/repository/product/product_category_repository_impl.dart';
import 'package:admin_app/repository/product/product_repository.dart';
import 'package:admin_app/repository/product/product_repository_impl.dart';
import 'package:admin_app/repository/rider_repository.dart';
import 'package:admin_app/repository/store/store_repository.dart';
import 'package:admin_app/repository/store/store_repository_impl.dart';
import 'package:admin_app/repository/tag/tag_repository.dart';
import 'package:admin_app/repository/tag/tag_repository_impl.dart';
import 'package:admin_app/repository/user/user_repository.dart';
import 'package:admin_app/repository/user/user_repository_impl.dart';
import 'package:admin_app/repository/vehicle_repository.dart';
import 'package:admin_app/service/address_firestore_service.dart';
import 'package:admin_app/service/authentication_service.dart';
import 'package:admin_app/service/chat_rooms_firestore_service.dart';
import 'package:admin_app/service/delivery_firestore_service.dart';
import 'package:admin_app/service/delivery_network_service.dart';
import 'package:admin_app/service/firestore_parent_path_service.dart';
import 'package:admin_app/service/location_database_service.dart';
import 'package:admin_app/service/messages_firestore_service.dart';
import 'package:admin_app/service/orders_firestore_service.dart';
import 'package:admin_app/service/product_category_firestore_service.dart';
import 'package:admin_app/service/product_firestore_service.dart';
import 'package:admin_app/service/rider_firestore_service.dart';
import 'package:admin_app/service/settings_firestore_service.dart';
import 'package:admin_app/service/stores_firestore_service.dart';
import 'package:admin_app/service/tags_firestore_service.dart';
import 'package:admin_app/service/upload_file_service.dart';
import 'package:admin_app/service/user_firestore_service.dart';
import 'package:admin_app/service/vehicle_firestore_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

void main() async {
  EquatableConfig.stringify = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirestoreParentPathService _firestoreParentPathService =
      new FirestoreParentPathService();

  /// Firestore services are loaded that way to take advantage of flutter_bloc's
  /// repository proivder lazy loading
  runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
            create: (context) => ProductRepositoryImpl(
                productFirestoreService: new ProductFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider<ProductCategoryRepository>(
            create: (context) => ProductCategoryRepositoryImpl(
                productCategoryFirestoreService:
                    new ProductCategoryFirestoreService(
                        firestoreParentPathService:
                            _firestoreParentPathService))),
        RepositoryProvider<UserRepository>(
            create: (context) => UserRepositoryImpl(
                userFirestoreService: new UserFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService),
                storesFirestoreService: new StoresFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider<OrderRepository>(
            create: (context) => OrderRepositoryImpl(
                ordersFirestoreService: new OrdersFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider<AddressRepository>(
            create: (context) => AddressRepositoryImpl(
                addressFirestoreService: new AddressFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider<MessageRepository>(
            create: (context) => MessageRepositoryImpl(
                messagesFirestoreService: new MessagesFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider<ChatRoomRepository>(
            create: (context) => ChatRoomRepositoryImpl(
                chatRoomsFirestoreService: new ChatRoomsFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider<StoreRepository>(
            create: (context) => StoreRepositoryImpl(
                storesFirestoreService: new StoresFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider<TagRepository>(
            create: (context) => TagRepositoryImpl(
                tagsFirestoreService: new TagsFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider(
            create: (context) => DeliveryRepository(
                deliveryFirestoreService: new DeliveryFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService),
                deliveryNetworkService: DeliveryNetworkService(),
                locationDatabaseService: LocationDatabaseService())),
        RepositoryProvider(
            create: (repositoryContext) => VehicleRepository(
                vehicleFirestoreService: VehicleFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider(
            create: (repositoryContext) => RiderRepository(
                riderFirestoreService: RiderFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
        RepositoryProvider(
            create: (repositoryContext) => AdminSettingsRepository(
                adminSettingsFirestoreService: AdminSettingsFirestoreService(
                    firestoreParentPathService: _firestoreParentPathService))),
      ],
      child: Builder(
        builder: (builderContext) => MultiBlocProvider(providers: [
          BlocProvider(
            create: (blocContext) => AuthenticationBloc(
                userRepository:
                    RepositoryProvider.of<UserRepository>(blocContext),
                authenticationService: AuthenticationService()),
          ),
          BlocProvider(
            create: (blocContext) => RegisterBloc(
                addressRepository:
                    RepositoryProvider.of<AddressRepository>(blocContext),
                userRepository:
                    RepositoryProvider.of<UserRepository>(blocContext),
                storeRepository:
                    RepositoryProvider.of<StoreRepository>(blocContext),
                uploadFileService: UploadFileService()),
          ),
          BlocProvider<ProductBloc>(
              create: (blocContext) => ProductBloc(
                  RepositoryProvider.of<ProductRepository>(blocContext),
                  RepositoryProvider.of<ProductCategoryRepository>(blocContext),
                  RepositoryProvider.of<UserRepository>(blocContext),
                  UploadFileService(),
                  RepositoryProvider.of<TagRepository>(blocContext),
                  RepositoryProvider.of<OrderRepository>(blocContext))),
          BlocProvider<OrderBloc>(
            create: (blocContext) => OrderBloc(
                RepositoryProvider.of<OrderRepository>(blocContext),
                RepositoryProvider.of<ProductRepository>(blocContext),
                RepositoryProvider.of<UserRepository>(blocContext),
                RepositoryProvider.of<AddressRepository>(blocContext),
                RepositoryProvider.of<ChatRoomRepository>(blocContext)),
          ),
          BlocProvider<MessageBloc>(
            create: (blocContext) => MessageBloc(
                messageRepository:
                    RepositoryProvider.of<MessageRepository>(blocContext),
                chatRoomRepository:
                    RepositoryProvider.of<ChatRoomRepository>(blocContext),
                userRepository:
                    RepositoryProvider.of<UserRepository>(blocContext),
                storeRepository:
                    RepositoryProvider.of<StoreRepository>(blocContext),
                riderRepository:
                    RepositoryProvider.of<RiderRepository>(blocContext)),
          ),
          BlocProvider<StoreBloc>(
              create: (blocContext) => StoreBloc(
                  storeRepository:
                      RepositoryProvider.of<StoreRepository>(blocContext),
                  userRepository:
                      RepositoryProvider.of<UserRepository>(blocContext),
                  addressRepository:
                      RepositoryProvider.of<AddressRepository>(blocContext),
                  uploadFileService: UploadFileService())),
          BlocProvider(
              create: (blocContext) => DeliveryBloc(
                  deliveryRepository:
                      RepositoryProvider.of<DeliveryRepository>(blocContext),
                  addressRepository:
                      RepositoryProvider.of<AddressRepository>(blocContext),
                  userRepository:
                      RepositoryProvider.of<UserRepository>(blocContext),
                  orderRepository:
                      RepositoryProvider.of<OrderRepository>(blocContext),
                  riderRepository:
                      RepositoryProvider.of<RiderRepository>(blocContext),
                  vehicleRepository:
                      RepositoryProvider.of<VehicleRepository>(blocContext),
                  productRepository:
                      RepositoryProvider.of<ProductRepository>(blocContext))),
          BlocProvider(
              create: (blocContext) => ReportsBloc(
                  userRepository:
                      RepositoryProvider.of<UserRepository>(blocContext),
                  addressRepository:
                      RepositoryProvider.of<AddressRepository>(blocContext),
                  productRepository:
                      RepositoryProvider.of<ProductRepository>(blocContext),
                  deliveryRepository:
                      RepositoryProvider.of<DeliveryRepository>(blocContext),
                  orderRepository:
                      RepositoryProvider.of<OrderRepository>(blocContext),
                  vehicleRepository:
                      RepositoryProvider.of<VehicleRepository>(blocContext),
                  storeRepository:
                      RepositoryProvider.of<StoreRepository>(blocContext),
                  riderRepository:
                      RepositoryProvider.of<RiderRepository>(blocContext))),
          BlocProvider(
              create: (blocContext) => SettingsBloc(
                  adminSettingsRepository:
                      RepositoryProvider.of<AdminSettingsRepository>(
                          blocContext))),
        ], child: SmartCityAdminApp()),
      )));
}
