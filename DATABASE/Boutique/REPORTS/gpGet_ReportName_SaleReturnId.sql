-- Function: gpGet_ReportName_SaleReturnId()

DROP FUNCTION IF EXISTS gpGet_ReportName_SaleReturnId (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_ReportName_SaleReturnId (
    IN inMovementId          Integer  , -- 
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

       -- ���������
       SELECT CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 'Print_Check' ELSE 'Print_Check_GoodsAccount' END
              INTO vbPrintFormName
       FROM Movement
       WHERE Movement.Id = inMovementId
       ;

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.02.18         *
*/

-- ����
-- SELECT * FROM gpGet_ReportName_SaleReturnId (inMovementId:= 1, inSession:= '5'); -- test