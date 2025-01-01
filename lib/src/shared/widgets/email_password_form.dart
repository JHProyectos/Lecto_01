import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// Formulario para ingresar el correo electrónico y la contraseña
class EmailPasswordForm extends StatefulWidget {
  // Función que se llama cuando se envía el formulario con el correo y la contraseña
  final Function(String email, String password) onSubmit;

  // Constructor del formulario que requiere la función onSubmit
  const EmailPasswordForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  // Clave global para el formulario que se usa para validar el estado del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para manejar los valores de los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Asigna la clave global al formulario
      child: Column(
        children: [
          // Campo para ingresar el correo electrónico
          TextFormField(
            controller: _emailController, // Controlador para manejar el valor del campo
            decoration: InputDecoration(
              labelText: 'auth.email'.tr(), // Texto del campo traducido
              icon: Icon(Icons.email), // Icono del campo
            ),
            keyboardType: TextInputType.emailAddress, // Tipo de teclado para el correo
            validator: (value) {
              // Valida que el campo no esté vacío
              if (value == null || value.isEmpty) {
                return 'auth.email_required'.tr(); // Mensaje de error traducido
              }
              return null; // Si es válido, no devuelve nada
            },
          ),
          SizedBox(height: 16), // Espaciado entre los campos
          
          // Campo para ingresar la contraseña
          TextFormField(
            controller: _passwordController, // Controlador para manejar el valor del campo
            decoration: InputDecoration(
              labelText: 'auth.password'.tr(), // Texto del campo traducido
              icon: Icon(Icons.lock), // Icono del campo
            ),
            obscureText: true, // Oculta el texto de la contraseña
            validator: (value) {
              // Valida que el campo no esté vacío
              if (value == null || value.isEmpty) {
                return 'auth.password_required'.tr(); // Mensaje de error traducido
              }
              return null; // Si es válido, no devuelve nada
            },
          ),
          SizedBox(height: 24), // Espaciado antes del botón de enviar
          
          // Botón para enviar el formulario
          ElevatedButton(
            onPressed: () {
              // Valida el formulario antes de enviar los datos
              if (_formKey.currentState!.validate()) {
                // Llama a la función onSubmit con el correo y la contraseña
                widget.onSubmit(_emailController.text, _passwordController.text);
              }
            },
            child: Text('auth.login'.tr()), // Texto del botón traducido
          ),
        ],
      ),
    );
  }

  // Limpia los controladores cuando el widget es destruido
  @override
  void dispose() {
    _emailController.dispose(); // Libera el controlador del correo electrónico
    _passwordController.dispose(); // Libera el controlador de la contraseña
    super.dispose();
  }
}
