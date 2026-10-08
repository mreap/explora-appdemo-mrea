import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colores tomados del diseño de Stitch.
const Color _surface = Color(0xFFFAF8FF);
const Color _primary = Color(0xFF00030B);
const Color _primaryContainer = Color(0xFF0B1E33);
const Color _primaryFixed = Color(0xFFD3E4FF);
const Color _secondary = Color(0xFF855300);
const Color _secondaryContainer = Color(0xFFFEA619);
const Color _secondaryFixed = Color(0xFFFFDDB8);
const Color _tertiaryFixed = Color(0xFF85F8C4);
const Color _onTertiaryContainer = Color(0xFF0C986B);
const Color _onSurfaceVariant = Color(0xFF44474D);
const Color _outline = Color(0xFF74777D);
const Color _outlineVariant = Color(0xFFC4C6CD);
const Color _surfaceContainer = Color(0xFFEAEDFF);
const Color _surfaceContainerHigh = Color(0xFFE2E7FF);

TextStyle _jakarta({
  required double size,
  double? height,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0,
  Color color = _primaryContainer,
}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    height: height == null ? null : height / size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    color: color,
  );
}

class BienvenidaScreenClaudeDesign extends StatelessWidget {
  const BienvenidaScreenClaudeDesign({
    super.key,
    this.onEmpezar,
    this.onOmitir,
  });

  final VoidCallback? onEmpezar;
  final VoidCallback? onOmitir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Stack(
        children: [
          // Luces ambientales de fondo.
          const Positioned(
            top: -96,
            left: 0,
            right: 0,
            child: Center(
              child: _LuzAmbiental(
                color: _primaryFixed,
                size: 384,
                alpha: 0.35,
              ),
            ),
          ),
          const Positioned(
            bottom: 40,
            right: -80,
            child: _LuzAmbiental(color: _secondaryFixed, size: 320, alpha: 0.3),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height / 3,
            left: -80,
            child: const _LuzAmbiental(
              color: _tertiaryFixed,
              size: 288,
              alpha: 0.2,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _BarraSuperior(onOmitir: onOmitir),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: const Center(child: _Contenido()),
                      ),
                    ),
                  ),
                ),
                _PiePagina(onEmpezar: onEmpezar),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LuzAmbiental extends StatelessWidget {
  const _LuzAmbiental({
    required this.color,
    required this.size,
    required this.alpha,
  });

  final Color color;
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarraSuperior extends StatelessWidget {
  const _BarraSuperior({this.onOmitir});

  final VoidCallback? onOmitir;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: 'Atrás',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back,
                size: 22,
                color: _primaryContainer,
              ),
            ),
            Text(
              'ExploraEC',
              style: _jakarta(
                size: 18,
                height: 24,
                weight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            TextButton(
              onPressed: onOmitir,
              style: TextButton.styleFrom(
                foregroundColor: _onSurfaceVariant,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Omitir',
                style: _jakarta(
                  size: 12,
                  height: 16,
                  weight: FontWeight.w600,
                  color: _onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 448),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const _IconoPrincipal(),
          const SizedBox(height: 32),
          const _Insignia(),
          const SizedBox(height: 8),
          Text(
            'ExploraEC',
            style: _jakarta(
              size: 32,
              height: 40,
              weight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              'Descubre los mejores lugares cerca de ti',
              textAlign: TextAlign.center,
              style: _jakarta(size: 16, height: 26, color: _onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(
                child: _TarjetaDestacada(
                  icono: Icons.near_me_outlined,
                  colorIcono: _primaryContainer,
                  texto: 'Rutas Vivas',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _TarjetaDestacada(
                  icono: Icons.wb_sunny_outlined,
                  colorIcono: _secondary,
                  texto: '4 Regiones',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _TarjetaDestacada(
                  icono: Icons.forest_outlined,
                  colorIcono: _onTertiaryContainer,
                  texto: 'Eco Guías',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _IconoPrincipal extends StatelessWidget {
  const _IconoPrincipal();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      height: 176,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _surfaceContainerHigh.withValues(alpha: 0.6),
            ),
          ),
          Container(
            width: 144,
            height: 144,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x140B1E33),
                  blurRadius: 32,
                  spreadRadius: -4,
                  offset: Offset(0, 12),
                ),
              ],
            ),
          ),
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [_surfaceContainer, Colors.white],
              ),
              border: Border.all(color: _outlineVariant.withValues(alpha: 0.4)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F0B1E33),
                  blurRadius: 24,
                  spreadRadius: -4,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primaryContainer,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.explore,
                          size: 34,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _secondaryContainer,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 11,
                          color: _primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Insignia extends StatelessWidget {
  const _Insignia();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _outlineVariant.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _onTertiaryContainer,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Ecuador a tu alcance',
            style: _jakarta(
              size: 11,
              height: 14,
              weight: FontWeight.w600,
              letterSpacing: 0.44,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaDestacada extends StatelessWidget {
  const _TarjetaDestacada({
    required this.icono,
    required this.colorIcono,
    required this.texto,
  });

  final IconData icono;
  final Color colorIcono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _outlineVariant.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080B1E33),
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 20, color: colorIcono),
          const SizedBox(height: 4),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: _jakarta(
              size: 11,
              height: 14,
              weight: FontWeight.w700,
              letterSpacing: 0.44,
              color: _onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PiePagina extends StatelessWidget {
  const _PiePagina({this.onEmpezar});

  final VoidCallback? onEmpezar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 448),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: onEmpezar ?? () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryContainer,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  elevation: 8,
                  shadowColor: _primaryContainer.withValues(alpha: 0.45),
                  textStyle: _jakarta(
                    size: 14,
                    height: 20,
                    weight: FontWeight.w600,
                    letterSpacing: 0.14,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Empezar'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Al continuar, aceptas descubrir maravillas locales',
              textAlign: TextAlign.center,
              style: _jakarta(
                size: 11,
                height: 14,
                weight: FontWeight.w700,
                letterSpacing: 0.44,
                color: _outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
