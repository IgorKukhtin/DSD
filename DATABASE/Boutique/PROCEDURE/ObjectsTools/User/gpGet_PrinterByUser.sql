-- Function: gpGet_PrinterByUnit()

DROP FUNCTION IF EXISTS gpGet_PrinterByUser (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PrinterByUser(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPrinter TVarChar;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
 
     vbPrinter := COALESCE ((SELECT OS_User_Printer.ValueData 
                             FROM ObjectString AS OS_User_Printer
                             WHERE OS_User_Printer.ObjectId = vbUserId
                               AND OS_User_Printer.DescId = zc_ObjectString_User_Printer()
                            ), '') :: TVarChar ;
     RETURN vbPrinter;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.04.18         *

*/

-- ����
-- SELECT * FROM gpGet_PrinterByUser (inSession:= zfCalc_UserAdmin())
