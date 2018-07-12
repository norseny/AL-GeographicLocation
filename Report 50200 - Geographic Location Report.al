report 50200 "Geographic Location Report"
{
  CaptionML=ENU='Geographic Location Report';
  ProcessingOnly=true;
  requestpage
  {
    layout
    {
      area(content)
      {
        group(CityInformation)
        {
          CaptionML=ENU='Type in city name';
          field(City; City)
          {
          }
        }
      }
    }
    actions
    { 
    }
  }

  trigger OnPostReport();
  var
    GetAPIData : Codeunit 50200;
  begin
    GetAPIData.Get(City)
  end;

  var
    City : Text;
}