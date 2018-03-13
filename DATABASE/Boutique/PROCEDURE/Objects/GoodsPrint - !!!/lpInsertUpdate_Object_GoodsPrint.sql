-- Function: lpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, Boolean, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsPrint(
 INOUT ioOrd               Integer,      -- � �/� ������ GoodsPrint
 INOUT ioUserId            Integer,      -- ������������ ������ GoodsPrint
    IN inUnitId            Integer,      --
    IN inPartionId         Integer,      --
    IN inAmount            TFloat,       --
    IN inIsReprice         Boolean,      --
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserName         TVarChar,     -- 
    IN inUserId            Integer       -- ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- ��������
   IF COALESCE (inPartionId, 0) = 0
   THEN
        RAISE EXCEPTION '������.�� ���������� �������� <������>.';
   END IF;


   -- !!!������� ������� ������ ���� ������������� ������ ��� �� 7 ����!!!
   DELETE FROM Object_GoodsPrint WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';


   -- ��� ������ ������ + ����������
   IF COALESCE (ioOrd, 0) = 0 AND inIsReprice = TRUE
   THEN
       -- ������� ������ "�� �������" + ����������
       vbInsertDate:= COALESCE ((SELECT tmp.InsertDate
                                 FROM gpSelect_Object_GoodsPrint_Choice (inUserId, inUserId :: TVarChar) AS tmp
                                 WHERE tmp.InsertDate >= CURRENT_DATE -- !!!"�� �������"!!!
                                   AND tmp.isReprice  = inIsReprice
                                 ORDER BY tmp.InsertDate DESC
                                 LIMIT 1)
                              , CURRENT_TIMESTAMP);

       -- ������ �� �������� ������������
       ioUserId := inUserId;

   -- ��� ������ ������
   ELSEIF COALESCE (ioOrd, 0) = 0
   THEN
       -- ������� � ������� ����/�����
       vbInsertDate := CURRENT_TIMESTAMP;
       -- ������� ��� �������� ������������
       ioUserId := inUserId;
       -- ��� ��� �������� - �� ����������
       inIsReprice:= FALSE;

   ELSE
       -- ����� ������� ������, ���� ������� ����� + ������ isReprice
       SELECT tmp.InsertDate, tmp.isReprice
              INTO vbInsertDate, inIsReprice
       FROM gpSelect_Object_GoodsPrint_Choice (ioUserId, inUserId :: TVarChar) AS tmp
       WHERE tmp.Ord = ioOrd -- !!!������� ������ ������!!!
       ;
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
   WHERE Object_GoodsPrint.InsertDate = vbInsertDate
     AND Object_GoodsPrint.UserId     = ioUserId
     AND Object_GoodsPrint.PartionId  = inPartionId
     AND Object_GoodsPrint.UnitId     = inUnitId
     AND Object_GoodsPrint.isReprice  = inIsReprice
   ;

   -- ���� ����� ������� �� ��� ������
   IF NOT FOUND
   THEN
       -- �������� ����� �������
       INSERT INTO Object_GoodsPrint (PartionId, UnitId, UserId, Amount, InsertDate, isReprice)
                              VALUES (inPartionId, inUnitId, ioUserId, inAmount, vbInsertDate, inIsReprice);
   END IF; -- if NOT FOUND


   -- ��������� - ���������� � �/� ������ + ��������
   SELECT tmp.Ord, tmp.UserName, tmp.Name
          INTO ioOrd, outUserName, outGoodsPrintName
   FROM gpSelect_Object_GoodsPrint_Choice (ioUserId, inUserId :: TVarChar) AS tmp
   WHERE tmp.InsertDate = vbInsertDate
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 06.03.18                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_GoodsPrint (ioOrd:= 0, ioUserId:= 0, inUnitId:= 4198, inPartionId:= 0, inAmount:= 5, inIsReprice:= FALSE, inUserId := zfCalc_UserAdmin() :: Integer);
