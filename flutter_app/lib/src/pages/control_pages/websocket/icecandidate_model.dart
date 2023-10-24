// iceCandidate_model
class IceCandidateModel {
  String? candidate;
  String? sdpMid;
  int? sdpMLineIndex;
  String? to;

  IceCandidateModel({
    this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
    this.to,
  });

  factory IceCandidateModel.fromJson(Map json) {
    return IceCandidateModel(
      candidate: json['candidate'],
      sdpMid: json['sdpMid'],
      sdpMLineIndex: json['sdpMLineIndex'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate': candidate,
      'sdpMid': sdpMid,
      'sdpMLineIndex': sdpMLineIndex,
      'to': to
    };
  }
}

// webrtc_model
class WebRTCModel {
  String? from;
  String? to;
  String? offerSDP;
  String? offerType;
  String? answerSDP;
  String? answerType;
  bool? audioOnly;

  WebRTCModel({
    this.from,
    this.to,
    this.offerSDP,
    this.offerType,
    this.answerSDP,
    this.answerType,
    this.audioOnly,
  });

  factory WebRTCModel.fromJson(Map json) {
    return WebRTCModel(
        from: json['from'],
        to: json['to'],
        offerSDP: json['offerSDP'],
        offerType: json['offerType'],
        answerSDP: json['answerSDP'],
        answerType: json['answerType'],
        audioOnly: json['audioOnly']);
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'offerSDP': offerSDP,
      'offerType': offerType,
      'answerSDP': answerSDP,
      'answerType': answerType,
      'audioOnly': audioOnly
    };
  }
}
