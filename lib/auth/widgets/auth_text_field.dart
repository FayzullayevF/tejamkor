import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AuthFieldType { name, email, password, phone }

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.type,
    this.hintText,
    this.labelText,
    this.svgAsset,
    this.onChanged,
    this.enabled = true,
    this.autofillHints,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
  });

  final TextEditingController controller;
  final AuthFieldType type;
  final String? hintText;
  final String? labelText;
  final String? svgAsset;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  bool get _isPassword => widget.type == AuthFieldType.password;

  String get _defaultHint {
    switch (widget.type) {
      case AuthFieldType.name:
        return "Ismingizni kiriting";
      case AuthFieldType.email:
        return "Emailingizni kiriting";
      case AuthFieldType.password:
        return "Parol kiriting";
      case AuthFieldType.phone:
        return "Telefon raqam";
    }
  }

  String get _defaultLabel {
    switch (widget.type) {
      case AuthFieldType.name:
        return "To‘liq ismingiz";
      case AuthFieldType.email:
        return "Email pochtangiz";
      case AuthFieldType.password:
        return "Parol";
      case AuthFieldType.phone:
        return "Telefon raqam";
    }
  }

  String get _defaultSvg {
    switch (widget.type) {
      case AuthFieldType.name:
        return "assets/icons/profile.svg";
      case AuthFieldType.email:
        return "assets/icons/communication.svg";
      case AuthFieldType.password:
        return "assets/icons/lock.svg";
      case AuthFieldType.phone:
        return "assets/icons/profile.svg";
    }
  }

  TextInputType get _keyboardType {
    switch (widget.type) {
      case AuthFieldType.name:
        return TextInputType.name;
      case AuthFieldType.email:
        return TextInputType.emailAddress;
      case AuthFieldType.password:
        return TextInputType.visiblePassword;
      case AuthFieldType.phone:
        return TextInputType.phone;
    }
  }

  List<TextInputFormatter> get _formatters {
    if (widget.type == AuthFieldType.phone) {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
        LengthLimitingTextInputFormatter(16),
      ];
    }
    if (widget.type == AuthFieldType.name) {
      return [
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\u0400-\u04FF' ]")),
        LengthLimitingTextInputFormatter(40),
      ];
    }
    if (widget.type == AuthFieldType.password) {
      return [LengthLimitingTextInputFormatter(64)];
    }
    return [LengthLimitingTextInputFormatter(60)];
  }

  String? validator(String? value) {
    final v = (value ?? "").trim();

    switch (widget.type) {
      case AuthFieldType.name:
        if (v.isEmpty) return "Ismni kiriting";
        if (v.length < 2) return "Ism juda qisqa";
        return null;

      case AuthFieldType.email:
        if (v.isEmpty) return "Emailni kiriting";
        final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$').hasMatch(v);
        if (!ok) return "Email noto‘g‘ri formatda";
        return null;

      case AuthFieldType.password:
        if (v.isEmpty) return "Parolni kiriting";
        if (v.length < 8) return "Parol kamida 8 ta belgi bo‘lsin";
        final hasUpper = RegExp(r'[A-Z]').hasMatch(v);
        final hasLower = RegExp(r'[a-z]').hasMatch(v);
        final hasDigit = RegExp(r'[0-9]').hasMatch(v);
        if (!hasUpper || !hasLower || !hasDigit) {
          return "Parolda katta harf, kichik harf va raqam bo‘lsin";
        }
        return null;

      case AuthFieldType.phone:
        if (v.isEmpty) return "Telefon raqamni kiriting";
        final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length < 9) return "Telefon raqam juda qisqa";
        return null;
    }
  }

  void _onSubmitted(String _) {
    if (widget.nextFocusNode != null) {
      widget.nextFocusNode!.requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final svg = widget.svgAsset ?? _defaultSvg;

    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _isPassword ? _obscure : false,
      keyboardType: _keyboardType,
      textInputAction:
          widget.textInputAction ??
          (widget.nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done),
      inputFormatters: _formatters,
      validator: validator,
      onChanged: widget.onChanged,
      autofillHints: widget.autofillHints ?? _autoFillHintsByType(widget.type),
      focusNode: widget.focusNode,
      onFieldSubmitted: _onSubmitted,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
        decoration: InputDecoration(
          labelText: widget.labelText ?? _defaultLabel,

          floatingLabelBehavior: FloatingLabelBehavior.auto,

          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9AA3AE),
          ),

          floatingLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9AA3AE),
          ),

          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: SvgPicture.asset(
              svg,
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
            ),
          ),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 56,
            minHeight: 74,
          ),

          suffixIcon: _isPassword
              ? IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 22,
              color: const Color(0xFF9AA3AE),
            ),
          )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 22,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFD7DCE2),
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF2BB9B1),
              width: 1.4,
            ),
          ),
        )
    );
  }

  List<String> _autoFillHintsByType(AuthFieldType t) {
    switch (t) {
      case AuthFieldType.name:
        return const [AutofillHints.name];
      case AuthFieldType.email:
        return const [AutofillHints.email];
      case AuthFieldType.password:
        return const [AutofillHints.password];
      case AuthFieldType.phone:
        return const [AutofillHints.telephoneNumber];
    }
  }
}
