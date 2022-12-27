class EmployeeAppointmentConfirmModel {
  final int id;
  final String date;
  final String status;
  final total;
  final String customerName;
  final String customerPhoneNumber;
  final String customerImage;
  final String serviceName;
  final String updateTime;
  final String rescheduleType;
  final String dateReschedule;
  final int? employeeRating;
  final int? serviceRating;
  bool isExpanded;

  EmployeeAppointmentConfirmModel( {
    required this.isExpanded,
    required this.id,
    required this.date,
    required this.status,
    this.total,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.customerImage,
    required this.serviceName,
    required this.updateTime,
    required this.rescheduleType,
    required this.dateReschedule,
    this.employeeRating,
    this.serviceRating,
  });

  factory EmployeeAppointmentConfirmModel.fromJson(Map<String, dynamic> json) {
    return EmployeeAppointmentConfirmModel(
        isExpanded: false,
        id: json['id'] == null ? 0 : json['id'], 
        date: json['date'],
        status: json['status'],
        total:  double.parse(json['total']),
        customerName: json['customerName'],
        customerPhoneNumber: json['customerPhoneNumber'],
        customerImage:  json['customerImage'],
        serviceName: json['serviceName'],
        updateTime: json['updateTime'] == null ? "" : json['updateTime'],
        rescheduleType: json['rescheduleType'] == null ? "" : json['rescheduleType'],
        dateReschedule: json['dateReschedule'] ==null ? "" : json['dateReschedule'],
        employeeRating: json['employeeRating'] == null ? 0 : json['employeeRating'],
        serviceRating: json['employeeRating'] == null ? 0 : json['employeeRating']
    );
  }
}
