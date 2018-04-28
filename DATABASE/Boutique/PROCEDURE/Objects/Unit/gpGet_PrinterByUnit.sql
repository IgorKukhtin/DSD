-- Function: gpGet_PrinterByUnit()

DROP FUNCTION IF EXISTS gpGet_PrinterByUnit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PrinterByUnit(
    IN inUnitId        Integer,
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
 
     vbPrinter := COALESCE ((SELECT OS_Unit_Printer.ValueData 
                             FROM ObjectString AS OS_Unit_Printer
                             WHERE OS_Unit_Printer.ObjectId = inUnitId
                               AND OS_Unit_Printer.DescId = zc_ObjectString_Unit_Printer()
                            ), '') :: TVarChar ;
     RETURN vbPrinter;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.02.18         *

*/

-- ����
-- SELECT * FROM gpGet_PrinterByUnit (inUnitId:=1159, inSession:= '2')