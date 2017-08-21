-- Function: gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPrint(
 INOUT ioId                Integer,       -- ���� ������� <>            
 INOUT ioUserId            Integer,
    IN inUnitId            Integer,       -- 
    IN inPartionId         Integer,       --
    IN inAmount            TFloat,       -- 
   OUT outGoodsPrintName   TVarChar,     --
    IN inSession           TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inPartionId, 0) = 0
   THEN
        RAISE EXCEPTION '������.�� ���������� �������� <������>.';
   END IF;
   
   IF COALESCE (ioId, 0) = 0
   THEN
       vbInsertDate := CURRENT_TIMESTAMP;
       
       ioUserId := vbUserId;
       
       ioId := (SELECT COALESCE (MAX (tmp.ord), 0) + 1
               FROM  (SELECT Object_GoodsPrint.InsertDate
                           , ROW_NUMBER() OVER( PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate)  AS ord  
                      FROM Object_GoodsPrint
                      WHERE Object_GoodsPrint.UserId = ioUserId
                      GROUP BY Object_GoodsPrint.UserId, Object_GoodsPrint.InsertDate
                      ) AS tmp 
                 ) ;
   ELSE
       vbInsertDate := (SELECT tmp.InsertDate 
                        FROM  (SELECT Object_GoodsPrint.InsertDate
                                    , ROW_NUMBER() OVER( PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate)  AS ord  
                               FROM Object_GoodsPrint
                               WHERE Object_GoodsPrint.UserId = ioUserId
                               GROUP BY Object_GoodsPrint.UserId, Object_GoodsPrint.InsertDate
                               ) AS tmp 
                        WHERE tmp.Ord = ioId) :: TDateTime;
   END IF;
   outGoodsPrintName := (lfGet_Object_ValueData (vbUserId) ||' ' || vbInsertDate) :: TVarChar;
   
   -- �������� ������� 
   UPDATE Object_GoodsPrint 
   SET Amount = inAmount
   WHERE InsertDate = vbInsertDate AND UserId = ioUserId AND UnitId = inUnitId AND PartionId = inPartionId;

   -- ���� ����� ������� �� ��� ������
   IF NOT FOUND 
   THEN
       -- �������� ����� ������� 
       INSERT INTO Object_GoodsPrint (PartionId, UnitId, UserId, Amount, InsertDate)
                   VALUES (inPartionId, inUnitId, ioUserId, inAmount, vbInsertDate);
   END IF; -- if NOT FOUND
   
      
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
-- select * from gpInsertUpdate_Object_GoodsPrint(ioId := 0 , ioUserId := 0 , inUnitId := 4198 , inPartionId := 0 , inAmount := 5 ::TFloat,  inSession := '2'::TVarChar);