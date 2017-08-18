-- Function: gpDelete_Object_GoodsPrint (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_GoodsPrint (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_GoodsPrint(
 INOUT ioId                Integer,       -- ���� ������� <>            
 INOUT ioUserId            Integer,
   OUT outInsertDate       TDateTime,     -- 
   OUT outGoodsPrintName   TVarChar,     --
    IN inSession           TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (ioId, 0) = 0
   THEN
        RETURN;
   END IF;
   
   outInsertDate := (SELECT tmp.InsertDate 
                     FROM  (SELECT Object_GoodsPrint.InsertDate
                                 , ROW_NUMBER() OVER( PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate)  AS ord  
                            FROM Object_GoodsPrint
                            WHERE Object_GoodsPrint.UserId = ioUserId
                            GROUP BY Object_GoodsPrint.UserId, Object_GoodsPrint.InsertDate
                            ) AS tmp 
                     WHERE tmp.Ord = ioId) :: TDateTime;
                        
   -- ������� ��� �������� ������� ������ ������������ 
   DELETE FROM Object_GoodsPrint 
   WHERE InsertDate = outInsertDate AND UserId = ioUserId;

   ioUserId := 0;
   ioId := 0 ;
   outInsertDate := Null;
   outGoodsPrintName := '' :: TVarChar;
      
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
17.08.17          *
*/

-- ����
-- select * from gpDelete_Object_GoodsPrint(ioId := 0 , ioUserId := 0 , inSession := '2'::TVarChar);