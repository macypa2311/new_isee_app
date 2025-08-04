enum Rolle { superadmin, admin, installateur, planer, endkunde }

extension RolleExtension on Rolle {
  String get deutsch {
    return switch (this) {
      Rolle.superadmin => 'Superadmin',
      Rolle.admin => 'Admin',
      Rolle.installateur => 'Installateur',
      Rolle.planer => 'Planer',
      Rolle.endkunde => 'Endkunde',
    };
  }
}