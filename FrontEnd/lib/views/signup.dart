import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Asegúrate de que el archivo login.dart exista y esté importado correctamente

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int _currentStep = 0;
  PageController _pageController = PageController();

  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;

  void nextPage() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            "REGÍSTRATE",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 40), // Espacio adicional
                        FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: Text(
                            "Crea una cuenta :D",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30), // Espacio adicional
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _currentStep >= index ? Color(0xFF97C5D8) : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (index < 2)
                              Container(
                                width: 40,
                                height: 2,
                                color: _currentStep > index ? Color(0xFF97C5D8) : Colors.grey,
                              ),
                          ],
                        );
                      }),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentStep = index;
                          });
                        },
                        children: [
                          _buildStep1(),
                          _buildStep2(),
                          _buildStep3(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _currentStep > 0
                              ? FadeInUp(
                                  duration: Duration(milliseconds: 1500),
                                  child: MaterialButton(
                                    minWidth: 100,
                                    height: 60,
                                    onPressed: previousPage,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      "Volver",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          FadeInUp(
                            duration: Duration(milliseconds: 1500),
                            child: Container(
                              padding: EdgeInsets.only(top: 3, left: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.black),
                              ),
                              child: MaterialButton(
                                minWidth: 100,
                                height: 60,
                                onPressed: nextPage,
                                color: Color(0xFF97C5D8), // Color principal
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  _currentStep < 2 ? "Siguiente" : "Registrarse",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Ya tienes una cuenta?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ), // Asegúrate de que LoginPage exista en login.dart
                              );
                            },
                            child: Text(
                              " Login",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: const Color.fromARGB(255, 63, 141, 205),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInUp(
            duration: Duration(milliseconds: 1200),
            child: makeInput(label: "Nombre"),
          ),
          FadeInUp(
            duration: Duration(milliseconds: 1200),
            child: makeInput(label: "Apellido"),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInUp(
            duration: Duration(milliseconds: 1200),
            child: makeInput(label: "Email"),
          ),
          FadeInUp(
            duration: Duration(milliseconds: 1300),
            child: makeInput(
              label: "Contraseña",
              obscureText: !_isPasswordVisible1,
              toggleVisibility: () {
                setState(() {
                  _isPasswordVisible1 = !_isPasswordVisible1;
                });
              },
              isPasswordVisible: _isPasswordVisible1,
            ),
          ),
          FadeInUp(
            duration: Duration(milliseconds: 1400),
            child: makeInput(
              label: "Verificar Contraseña",
              obscureText: !_isPasswordVisible2,
              toggleVisibility: () {
                setState(() {
                  _isPasswordVisible2 = !_isPasswordVisible2;
                });
              },
              isPasswordVisible: _isPasswordVisible2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInUp(
            duration: Duration(milliseconds: 1400),
            child: makeInput(
              label: "Código Pin",
              obscureText: !_isPasswordVisible2,
              toggleVisibility: () {
                setState(() {
                  _isPasswordVisible2 = !_isPasswordVisible2;
                });
              },
              isPasswordVisible: _isPasswordVisible2,
            ),
          ),
          FadeInUp(
            duration: Duration(milliseconds: 1200),
            child: makeInput(label: "Placa"),
          ),
        ],
      ),
    );
  }

  Widget makeInput({required String label, bool obscureText = false, VoidCallback? toggleVisibility, bool isPasswordVisible = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            suffixIcon: toggleVisibility != null
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: toggleVisibility,
                  )
                : null,
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
