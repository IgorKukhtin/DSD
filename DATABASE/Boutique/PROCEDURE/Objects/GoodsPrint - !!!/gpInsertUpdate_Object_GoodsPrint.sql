-- Function: gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPrint(
 INOUT ioOrd               Integer,      -- � �/� ������ GoodsPrint
 INOUT ioUserId            Integer,      -- ������������ ������ GoodsPrint
    IN inUnitId            Integer,      --
    IN inPartionId         Integer,      --
    IN inAmount            TFloat,       --
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserName         TVarChar,     -- 
    IN inSession           TVarChar      -- ������ ������������
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


   -- ��������
   IF COALESCE (inPartionId, 0) = 0
   THEN
        RAISE EXCEPTION '������.�� ���������� �������� <������>.';
   END IF;


   -- !!!������� ������� ������ ���� ������������� ������ ��� �� 7 ����!!!
   DELETE FROM Object_GoodsPrint WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';


   -- ��� ������ ������
   IF COALESCE (ioOrd, 0) = 0
   THEN
       -- ������� � ������� ����/�����
       vbInsertDate := CURRENT_TIMESTAMP;
       -- ������� ��� �������� ������������
       ioUserId := vbUserId;

   ELSE
       -- ����� ������� ������, ���� ������� �����
       vbInsertDate := (SELECT tmp.InsertDate FROM gpSelect_Object_GoodsPrint_Choice (ioUserId, inSession) AS tmp
                        WHERE tmp.Ord = ioOrd -- !!!������� ������ ������!!!
                       );
       -- �������� - �.�. ������ ������ ��������� ����� 7 ����, ������ � ���� ��������
       IF vbInsertDate <= CURRENT_DATE - INTERVAL '5 DAY'
       THEN
           RAISE EXCEPTION '������.������ ��������� ������ � ������ �������� �� <%>.����� ������� ������ � ����� ������ <%>'
                         , zfConvert_DateTimeToString (vbInsertDate)
                         , zfConvert_DateToString (CURRENT_DATE - INTERVAL '5 DAY');
       END IF;
       
   END IF;


   -- �������� �������
   UPDATE Object_GoodsPrint SET Amount = inAmount
   WHERE Object_GoodsPrint.InsertDate = vbInsertDate AND Object_GoodsPrint.UserId = ioUserId AND Object_GoodsPrint.PartionId = inPartionId
     AND Object_GoodsPrint.UnitId = inUnitId
   ;

   -- ���� ����� ������� �� ��� ������
   IF NOT FOUND
   THEN
       -- �������� ����� �������
       INSERT INTO Object_GoodsPrint (PartionId, UnitId, UserId, Amount, InsertDate, isReprice)
                              VALUES (inPartionId, inUnitId, ioUserId, inAmount, vbInsertDate, FALSE);
   END IF; -- if NOT FOUND


   -- ��������� - ���������� � �/� ������ + ��������
   SELECT tmp.Ord, tmp.UserName, tmp.Name
          INTO ioOrd, outUserName, outGoodsPrintName
   FROM gpSelect_Object_GoodsPrint_Choice (ioUserId, inSession) AS tmp
   WHERE tmp.InsertDate = vbInsertDate
   ;

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
-- SELECT * FROM gpInsertUpdate_Object_GoodsPrint (ioOrd:= 0, ioUserId:= 0, inUnitId:= 4198, inPartionId:= 0, inAmount:= 5, inSession := zfCalc_UserAdmin());
