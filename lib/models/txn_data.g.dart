// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TxnDataAdapter extends TypeAdapter<TxnData> {
  @override
  final int typeId = 0;

  @override
  TxnData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TxnData(
      txnId: fields[0] as int,
      service: fields[1] as String,
      msisdn: fields[2] as String,
      serviceProvider: fields[3] as String,
      serviceProviderRef: fields[4] as String,
      amount: fields[5] as double,
      desc: fields[6] as String,
      agentsCommission: fields[9] as double,
      broadpaysCommission: fields[10] as double,
      status: fields[11] as String,
      token: fields[13] as String,
      meterNumber: fields[14] as String,
      customerName: fields[21] as String,
      isError: fields[12] as bool,
      msg: fields[15] as String,
      txnDateTime: fields[16] as String,
      sender: fields[18] as String,
      recipient: fields[19] as String,
      created: fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TxnData obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.txnId)
      ..writeByte(1)
      ..write(obj.service)
      ..writeByte(2)
      ..write(obj.msisdn)
      ..writeByte(3)
      ..write(obj.serviceProvider)
      ..writeByte(4)
      ..write(obj.serviceProviderRef)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.desc)
      ..writeByte(9)
      ..write(obj.agentsCommission)
      ..writeByte(10)
      ..write(obj.broadpaysCommission)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.isError)
      ..writeByte(13)
      ..write(obj.token)
      ..writeByte(14)
      ..write(obj.meterNumber)
      ..writeByte(15)
      ..write(obj.msg)
      ..writeByte(16)
      ..write(obj.txnDateTime)
      ..writeByte(18)
      ..write(obj.sender)
      ..writeByte(19)
      ..write(obj.recipient)
      ..writeByte(20)
      ..write(obj.created)
      ..writeByte(21)
      ..write(obj.customerName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TxnDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
