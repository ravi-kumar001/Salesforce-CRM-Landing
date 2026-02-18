public class PdfCtrl{
 public List<Contact> cons;

 public PdfCtrl(){
  String acc=ApexPages.currentPage()
  .getParameters().get('acc');

  cons=[SELECT Name,Email
  FROM Contact
  WHERE AccountId=:acc];
 }
}