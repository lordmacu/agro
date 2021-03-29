class Helpers{
  String removeDiacritics(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str.toLowerCase();
  }


  List<String> filterStrings(array,item){
    List<String> suggestionsLocal = [];

    if(item.length>0){
      array.forEach((userDetail) {
        if (this.removeDiacritics(userDetail).contains(this.removeDiacritics(item)))
          suggestionsLocal.add(userDetail);
      });
    }
    return suggestionsLocal;
  }

  List<String> filterStringsAll(array,item){
    List<String> suggestionsLocal = [];


      array.forEach((userDetail) {
        if (this.removeDiacritics(userDetail).contains(this.removeDiacritics(item)))
          suggestionsLocal.add(userDetail);
      });

    return suggestionsLocal;
  }
}