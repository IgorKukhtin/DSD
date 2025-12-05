-- Function: gpGet_Movement_OrderFinance_FileName_xls(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_FileName_xls (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_FileName_xls(
   OUT outFileName            TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   , 
   OUT outExportType          TVarChar  ,
    IN inMovementId           Integer   ,
    IN inSession              TVarChar
)


   OUT outFileName            TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   ,
   OUT outExportType          TVarChar  ,
   OUT outExportKindId        Integer   ,



  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     SELECT COALESCE (Object_OrderFinance.ValueData, '')
            || '_' || COALESCE (Object_Insert.ValueData,'' )
            || '_' || REPLACE (zfConvert_DateShortToString (Movement.OperDate), '.', '')
          --  || '_' || Movement.InvNumber  
                           AS outFileName
          , 'xls'                         AS outDefaultFileExt
          , FALSE                         AS outEncodingANSI
          , 'cxegExportToExcel'           AS outExportType
   INTO outFileName, outDefaultFileExt, outEncodingANSI, outExportType
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                       ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                      AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
          LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = MovementLinkObject_OrderFinance.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                       ON MovementLinkObject_Insert.MovementId = Movement.Id
                                      AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId
     WHERE Movement.Id = inMovementId;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.11.25         *
*/


-- тест
-- SELECT * FROM gpGet_Movement_OrderFinance_FileName_xls (inMovementId:= 32907603 , inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
