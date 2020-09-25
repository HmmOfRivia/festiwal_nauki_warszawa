class Event {
  final String nid;
  var domain;
  final List form;
  final String host;
  var date;
  var city;
  var postalcode;
  var street;
  final String title;
  var description;

  Event(this.nid, this.domain, this.form, this.host, this.date, this.city,
      this.postalcode, this.street, this.title, this.description);
}
