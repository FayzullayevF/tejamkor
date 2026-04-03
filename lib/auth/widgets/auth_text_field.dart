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
    this.validatorOverride,
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
  final String? Function(String?)? validatorOverride;

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

  String? _errorText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (_errorText != null) {
      final err = _internalValidator(widget.controller.text);
      if (_errorText != err) {
        setState(() => _errorText = err);
      } else {
        setState(() {}); // Rebuild to update empty state checks
      }
    }
  }

  String? _internalValidator(String? value) {
    if (widget.validatorOverride != null) {
      return widget.validatorOverride!(value);
    }

    final v = (value ?? "").trim();

    switch (widget.type) {
      case AuthFieldType.name:
        if (v.isEmpty) return "Ismni kiriting";
        if (v.length < 2) return "Ism juda qisqa";
        return null;

      case AuthFieldType.email:
        if (v.isEmpty) return "Maydonni bo'sh qoldirmang";
        final isEmail = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$').hasMatch(v);
        final isPhone = RegExp(r'^\+?[0-9\-\s]{7,15}$').hasMatch(v);
        if (!isEmail && !isPhone) return "Noto‘g‘ri email yoki telefon formati";
        return null;

      case AuthFieldType.password:
        if (v.isEmpty) return "Parolni kiriting";
        if (v.length < 8) return "Parol kamida 8 ta belgi bo‘lsin";
        
        final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(v);
        final hasDigit = RegExp(r'[0-9]').hasMatch(v);
        final hasSymbol = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\+=~`\[\]\\/]').hasMatch(v);

        if (!hasLetter) {
          return "Parolda kamida 1 ta harf qatnashishi kerak";
        }
        if (!hasDigit) {
          return "Parolda kamida 1 ta raqam qatnashishi kerak";
        }
        if (!hasSymbol) {
          return "Parolda kamida 1 ta maxsus belgi qatnashishi kerak";
        }
        
        return null;

      case AuthFieldType.phone:
        if (v.isEmpty) return "Telefon raqamni kiriting";
        final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length < 9) return "Telefon raqam juda qisqa";
        return null;
    }
  }

  String? validator(String? value) {
    final err = _internalValidator(value);
    
    if (_errorText != err) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _errorText = err);
      });
    }

    if (err != null && (value == null || value.trim().isEmpty)) {
      return ''; // Native g'ururni yashiradi, xato rasmini beradi. Hint orqali ichida chiqaramiz.
    }
    return err;
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
          labelText: (_errorText != null && widget.controller.text.isEmpty)
              ? _errorText
              : (widget.labelText ?? _defaultLabel),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white,

          labelStyle: (_errorText != null && widget.controller.text.isEmpty)
              ? const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFEF4444),
                )
              : const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9AA3AE),
                ),

          floatingLabelStyle: (_errorText != null && widget.controller.text.isEmpty)
              ? const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFEF4444),
                )
              : const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9AA3AE),
                ),

          hintText: widget.hintText ?? _defaultHint,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFDCDCDC),
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

          contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 20),

          errorStyle: (_errorText != null && widget.controller.text.isEmpty)
              ? const TextStyle(
                  height: 0.0,
                  fontSize: 1.0,
                  color: Colors.transparent,
                )
              : const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFEF4444),
                  height: 1,
                ),
          errorMaxLines: 2,

          enabledBorder: RoundedRectInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFD7DCE2),
              width: 1,
            ),
          ),

          focusedBorder: RoundedRectInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF2BB9B1),
              width: 1.4,
            ),
          ),
          
          errorBorder: RoundedRectInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFEF4444),
              width: 1,
            ),
          ),
          
          focusedErrorBorder: RoundedRectInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFEF4444),
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

class RoundedRectInputBorder extends InputBorder {
  const RoundedRectInputBorder({
    super.borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
  });

  final BorderRadius borderRadius;

  @override
  bool get isOutline => false;

  @override
  RoundedRectInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
  }) {
    return RoundedRectInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderSide.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.resolve(textDirection).toRRect(rect);
    canvas.drawRRect(outer, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return RoundedRectInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
    );
  }
}
