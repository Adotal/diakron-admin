// enum ValidationStatus { uploading, pending, approved, denied }

// class CollectionCenter {
//   CollectionCenter({
//     this.id,
//     this.email,
//     this.validationStatus,
//     this.username,
//     this.surnames,
//     this.phoneNumber,
//     this.curpRep,
//     this.password,
//     this.companyName,
//     this.rfc,
//     this.taxRegime,
//     this.taxpayerType,
//     this.commercialName,
//     this.address,
//     this.billingEmail,
//     this.bank,
//     this.clabe,
//     this.pathIdRep,
//     this.pathProofAddress,
//     this.pathTaxCertificate,
//     this.scheduleMap,
//     this.postCode,
//     this.isActive,
//     this.createdAt,
//   });

//   final String? id;
//   final String? email;
//   final bool? isActive;

//   final DateTime? createdAt;

//   // Legal Representative
//   final String? username;
//   final String? surnames;
//   final String? phoneNumber;
//   final String? curpRep;
//   final String? password;
  

//   // Operation and Bank
//   final String? companyName;
//   final String? rfc;
//   final String? taxRegime;
//   final String? taxpayerType;
//   final String? commercialName;
//   final String? address;
//   final String? billingEmail;
//   final String? bank;
//   final String? clabe;
//   final String? postCode;
//   final Map<String, dynamic>? scheduleMap;

//   // Document Paths
//   final String? pathIdRep;
//   final String? pathProofAddress;
//   final String? pathTaxCertificate;


//   final ValidationStatus? validationStatus;

//   // Create a copy with updated fields (essential for ViewModels)
//   CollectionCenter copyWith({
//     String? id,
//     String? username,
//     String? surnames,
//     bool? isActive,
//     String? phoneNumber,
//     String? curpRep,
//     DateTime? createdAt,
//     String? email,
//     String? password,
//     String? companyName,
//     String? rfc,
//     String? taxRegime,
//     String? taxpayerType,
//     String? commercialName,
//     String? openTime,
//     String? closeTime,
//     String? address,
//     Map<String, dynamic>? scheduleMap,
//     String? postCode,
//     String? billingEmail,
//     String? bank,
//     String? clabe,
//     String? pathIdRep,
//     String? pathProofAddress,
//     String? pathTaxCertificate,
//     ValidationStatus? validationStatus,
//   }) {
//     return CollectionCenter(
//       id: id ?? this.id,
//       email: email ?? this.email,
//       isActive: isActive ?? this.isActive,
//       createdAt: createdAt ?? this.createdAt,
//       validationStatus: validationStatus ?? this.validationStatus,
//       username: username ?? this.username,
//       surnames: surnames ?? this.surnames,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       curpRep: curpRep ?? this.curpRep,
//       password: password ?? this.password,
//       companyName: companyName ?? this.companyName,
//       rfc: rfc ?? this.rfc,
//       taxRegime: taxRegime ?? this.taxRegime,
//       taxpayerType: taxpayerType ?? this.taxpayerType,
//       commercialName: commercialName ?? this.commercialName,
//       scheduleMap: scheduleMap ?? this.scheduleMap,
//       address: address ?? this.address,
//       billingEmail: billingEmail ?? this.billingEmail,
//       bank: bank ?? this.bank,
//       clabe: clabe ?? this.clabe,
//       pathIdRep: pathIdRep ?? this.pathIdRep,
//       pathProofAddress: pathProofAddress ?? this.pathProofAddress,
//       pathTaxCertificate: pathTaxCertificate ?? this.pathTaxCertificate,
//       postCode: postCode ?? this.postCode,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       // CollectionCenter User base data
//       // 'id': id,
//       // 'email': email,
//       // 'username': username,
//       // 'surnames': surnames,
//       // 'phone_number': phoneNumber,
//       // 'password': password,
//       // Furthermore data
//       'curp_rep': curpRep,
//       'company_name': companyName,
//       'rfc': rfc,
//       'tax_regime': taxRegime,
//       'taxpayer_type': taxpayerType,
//       'commercial_name': commercialName,
//       'post_code': postCode,
//       'schedule': scheduleMap,
//       'address': address,
//       'billing_email': billingEmail,
//       'bank': bank,
//       'clabe': clabe,
//       'path_id_rep': pathIdRep,
//       'path_proof_address': pathProofAddress,
//       'path_tax_certificate': pathTaxCertificate,
//       'validation_status': parseStatustoString(validationStatus),
//     };
//   }

//   // More data
//   // Factory para convertir lo que viene de Supabase (DatabaseService)
//   factory CollectionCenter.fromJson(Map<String, dynamic> map) {
//     return CollectionCenter(
//       // Base usr data
//       id: map['id'] ?? '',
//       email: map['email'] ?? '',
//       username: map['user_name'] ?? '',
//       surnames: map['surnames'] ?? '',
//       phoneNumber: map['phone_number'] ?? '',
//       isActive: map['is_active'] ?? false,
//       createdAt: map['created_at'] != null
//           ? DateTime.parse(map['created_at'])
//           : null,

//       // Company name data
//       companyName: map['company_name'] ?? '',
//       rfc: map['rfc'] ?? '',
//       taxRegime: map['tax_regime'] ?? '',
//       curpRep: map['curp_rep'] ?? '',
//       bank: map['bank'] ?? '',
//       clabe: map['clabe'] ?? '',
//       commercialName: map['commercial_name'] ?? '',
//       address: map['address'] ?? '',
//       billingEmail: map['billing_email'] ?? '',
//       taxpayerType: map['taxpayer_type'] ?? '',
//       pathIdRep: map['path_id_rep'] ?? '',
//       pathProofAddress: map['path_proof_address'] ?? '',
//       pathTaxCertificate: map['path_tax_certificate'] ?? '',
//       scheduleMap: map['schedule'],
//       postCode: map['post_code'] ?? '',

//       validationStatus: parseStatus(map['validation_status']),
//     );
//   }

//   static String? parseStatustoString(ValidationStatus? status) {
//     switch (status) {
//       case ValidationStatus.pending:
//         return 'PENDING';
//       case ValidationStatus.approved:
//         return 'APPROVED';
//       case ValidationStatus.denied:
//         return 'DENIED';
//       default:
//         return 'UPLOADING';
//     }
//   }

//   static ValidationStatus parseStatus(String? status) {
//     switch (status) {
//       case 'PENDING':
//         return ValidationStatus.pending;
//       case 'APPROVED':
//         return ValidationStatus.approved;
//       case 'DENIED':
//         return ValidationStatus.denied;
//       default:
//         return ValidationStatus.uploading;
//     }
//   }
// }
