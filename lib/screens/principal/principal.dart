// * SERVICES
import 'package:organic/methods/global_methods.dart';
import 'package:organic/models/product.dart';
import 'package:organic/models/user.dart';
import 'package:organic/screens/principal/product/detail_product.dart';
import 'package:organic/screens/principal/sales/confirm_sale.dart';
import 'package:organic/screens/principal/sales/modal_detail_sales.dart';
import 'package:organic/screens/principal/sales/my_sales.dart';
import 'package:organic/screens/principal/sales/sales_user_list.dart';
import 'package:organic/screens/principal/user/profile.dart';
import 'package:organic/screens/principal/user/user_manage.dart';
import 'package:organic/services/authentification/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:organic/util/queries/sales/sales_query.dart';
import 'package:organic/util/queries/user/user_query.dart';
import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// * FIREBASE
import 'package:organic/screens/public/Authentication/authentifcation.dart';
// * CONSTANT
import 'package:organic/constants/theme.dart';
import 'package:organic/constants/globals.dart' as global;
// * SCREENS
import 'package:organic/screens/principal/components/body.dart';
import 'package:organic/screens/principal/product/create_product.dart';
import 'package:organic/screens/principal/product/list_product.dart';

// ignore: must_be_immutable
class Principal extends StatefulWidget {
  UserLogin? user;

  // * Parametros de la vista
  // ? User: datos del usuario logeado
  Principal({Key? key, this.user}) : super(key: key);

  // * Referenciando al estado
  @override
  // ignore: no_logic_in_create_state
  PrincipalState createState() => PrincipalState(user: user);
}

class PrincipalState extends State<Principal> {
  // * Parametros del Estado de la vista
  // ? User: datos del usuario logeado
  PrincipalState({this.user});

  UserLogin? user;

  final UserQuery userQuery = UserQuery();

  int _selectDrawerItem = -1;
  Product? producto;

  // ignore: non_constant_identifier_names
  final SaleQuery sales_query = SaleQuery();

// * Switch para cambio de vista, según lo seleccionado en el menú lateral
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case -1:
        return Body(viewDetail: _onSelectItem, user: user);
      case 0:
        return CreateProduct(user: user);
      case 1:
        return CreateProduct(user: user);
      case 2:
        return ListProduct(user: user);
      case 3:
        return Profile(
          user: user,
          updateUser: updateUser,
        );

      case 4:
        return const SalesUserList();
      case 5:
        return const Authentication();
      case 6:
        return DetailProduct(product: producto!);
      case 7:
        return ConfirmSale(confirm: _onSelectItem);
      case 8:
        return const MySales();
      case 9:
        return const UserManage();
    }
  }

  // * Cambio de valor en la variable utilizada para validar que Vista mostrar
  _onSelectItem(int pos, Product? product) {
    if (product == null && pos != 7) Navigator.of(context).pop();
    setState(() {
      _selectDrawerItem = pos;
      producto = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildAppBar(),
      body: _getDrawerItemWidget(_selectDrawerItem),
      // bottomNavigationBar: navigationBar(),
      drawer: buildDrawerApp(context),
    );
  }

  void showMySales() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return ModalDetailSales(
            confirmSale: _onSelectItem,
          );
        });
  }

  Widget navigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: BottomNavigationBar(
        elevation: 0,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black26, size: 20),
            label: 'sadas',
            activeIcon: Icon(Icons.home, color: kPrimaryColor, size: 20),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.breakfast_dining, color: Colors.black26, size: 20),
            label: '',
            activeIcon:
                Icon(Icons.breakfast_dining, color: kPrimaryColor, size: 20),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits_rounded,
                color: Colors.black26, size: 20),
            label: '',
            activeIcon: Icon(Icons.production_quantity_limits_rounded,
                color: kPrimaryColor, size: 20),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.black26, size: 20),
            label: '',
            activeIcon:
                Icon(Icons.account_circle, color: kPrimaryColor, size: 20),
          ),
        ],
        currentIndex: _selectDrawerItem,
        selectedItemColor: Colors.amber[800],
        onTap: (value) {
          _onSelectItem(value, null);
        },
      ),
    );
  }

// * Menu superior
  AppBar buildAppBar() {
    return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
            color: _selectDrawerItem == 6 ? Colors.white : Colors.black54,
            size: 24,
            opacity: .5),
        backgroundColor: _selectDrawerItem == 6 ? kPrimaryColor : kPrimaryWhite,
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    showMySales();
                  },
                  backgroundColor: _selectDrawerItem == 6
                      ? Colors.white.withOpacity(0.13)
                      : Colors.black.withOpacity(0.13),
                  mini: true,
                  elevation: 0.0,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 20,
                    color:
                        _selectDrawerItem == 6 ? Colors.white : Colors.black54,
                  ),
                ),
                global.detailSales.isNotEmpty
                    ? Positioned(
                        right: 1,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: _selectDrawerItem == 6
                                ? kPrimaryWhite
                                : kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                              minWidth: 15,
                              minHeight: 15,
                              maxHeight: 15,
                              maxWidth: 15),
                          child: Text(
                            global.detailSales.length.toString(),
                            style: TextStyle(
                                color: _selectDrawerItem == 6
                                    ? Colors.black87
                                    : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : const SizedBox()
              ])),
        ]);
  }

  Future updateUser(UserLogin? userLogin) async {
    var userUpdated = await userQuery.updateUser(userLogin!);

    setState(() {
      user = userUpdated;
    });
  }

// * Menu lateral izquierdo
  Drawer buildDrawerApp(BuildContext context) {
    final logoutProvider = Provider.of<AuthServices>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          // * Datos del usuario
          UserAccountsDrawerHeader(
            accountName: Text(user == null || user?.type == 'VISITOR'
                ? 'Invitado'
                : user?.name as String),
            accountEmail: Text(user == null || user?.type == 'VISITOR'
                ? 'Invitado@gmail.com'
                : user?.email as String),
            currentAccountPicture: CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: Text(
                user == null || user?.type == 'VISITOR'
                    ? 'IN'
                    : (user?.email as String).substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 40.0, color: kPrimaryWhite),
              ),
            ),
          ),
          const Divider(
            thickness: 0.9,
          ),
          // * Vista principal, listado de todos los productos
          ListTile(
              title: Text('Home',
                  style: TextStyle(
                      color: -1 == _selectDrawerItem
                          ? kPrimaryColor
                          : Colors.black87)),
              leading: Icon(Icons.home,
                  color:
                      -1 == _selectDrawerItem ? kPrimaryColor : Colors.black54),
              selected: (-1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(-1, null);
              }),

          user == null || user?.type != 'ADMIN'
              ? const SizedBox()
              :
              // * Lista de todos los productos agregados por el usuario
              ListTile(
                  title: Text('Mis productos',
                      style: TextStyle(
                          color: 2 == _selectDrawerItem
                              ? kPrimaryColor
                              : Colors.black87)),
                  leading: Icon(Icons.breakfast_dining,
                      color: 2 == _selectDrawerItem
                          ? kPrimaryColor
                          : Colors.black54),
                  selected: (2 == _selectDrawerItem),
                  onTap: () {
                    _onSelectItem(2, null);
                  }),
          // * Creación de productos
          user == null || user?.type != 'ADMIN'
              ? const SizedBox()
              : ListTile(
                  title: Text('Crear producto',
                      style: TextStyle(
                          color: 1 == _selectDrawerItem
                              ? kPrimaryColor
                              : Colors.black87)),
                  leading: Icon(Icons.add,
                      color: 1 == _selectDrawerItem
                          ? kPrimaryColor
                          : Colors.black54),
                  selected: (1 == _selectDrawerItem),
                  onTap: () {
                    _onSelectItem(1, null);
                  }),

          user == null || user?.type == 'VISITOR'
              ? const SizedBox()
              : ListTile(
                  title: Text('Mis compras',
                      style: TextStyle(
                          color: 4 == _selectDrawerItem
                              ? kPrimaryColor
                              : Colors.black87)),
                  leading: Icon(Icons.production_quantity_limits_rounded,
                      color: 4 == _selectDrawerItem
                          ? kPrimaryColor
                          : Colors.black54),
                  selected: (4 == _selectDrawerItem),
                  onTap: () {
                    _onSelectItem(4, null);
                  }),

          user == null || user?.type != 'ADMIN'
              ? const SizedBox()
              : const Divider(
                  thickness: 0.9,
                ),

          user == null || user?.type != 'ADMIN'
              ? const SizedBox()
              : ListTile(
                  title: Text('Mis ventas',
                      style: TextStyle(
                          color: 8 == _selectDrawerItem
                              ? kPrimaryColor
                              : Colors.black87)),
                  leading: Icon(Icons.money,
                      color: 8 == _selectDrawerItem
                          ? kPrimaryColor
                          : Colors.black54),
                  selected: (8 == _selectDrawerItem),
                  onTap: () {
                    _onSelectItem(8, null);
                  }),

          user == null || user?.type != 'ADMIN'
              ? const SizedBox()
              : ListTile(
                  title: Text('Usuarios',
                      style: TextStyle(
                          color: 9 == _selectDrawerItem
                              ? kPrimaryColor
                              : Colors.black87)),
                  leading: Icon(Icons.group,
                      color: 9 == _selectDrawerItem
                          ? kPrimaryColor
                          : Colors.black54),
                  selected: (9 == _selectDrawerItem),
                  onTap: () {
                    _onSelectItem(9, null);
                  }),

          const Divider(
            thickness: 0.9,
          ),

          user == null || user?.type == 'VISITOR'
              ? const SizedBox()
              :
              // * Perfil de usuario
              ListTile(
                  title: Text('Perfil',
                      style: TextStyle(
                          color: 3 == _selectDrawerItem
                              ? kPrimaryColor
                              : Colors.black87)),
                  leading: Icon(Icons.account_circle,
                      color: 3 == _selectDrawerItem
                          ? kPrimaryColor
                          : Colors.black54),
                  selected: (3 == _selectDrawerItem),
                  onTap: () {
                    _onSelectItem(3, null);
                  }),
          // * Cierre de sesión

          user == null || user?.type == 'VISITOR'
              ? const SizedBox()
              : ListTile(
                  title: Text('Cerrar sesión',
                      style: TextStyle(
                          color: 5 == _selectDrawerItem
                              ? kPrimaryColor
                              : Colors.black87)),
                  leading: Icon(Icons.exit_to_app,
                      color: 5 == _selectDrawerItem
                          ? kPrimaryColor
                          : Colors.black54),
                  selected: (5 == _selectDrawerItem),
                  onTap: () {
                    logoutProvider.logout();
                    toMain(context);
                  }),

          user == null || user?.type == 'VISITOR'
              ? ListTile(
                  title: const Text('Iniciar sesión',
                      style: TextStyle(color: Colors.black87)),
                  leading: const Icon(Icons.login, color: Colors.black54),
                  selected: (5 == _selectDrawerItem),
                  onTap: () {
                    toMain(context);
                  })
              : const SizedBox()
        ],
      ),
    );
  }
}
