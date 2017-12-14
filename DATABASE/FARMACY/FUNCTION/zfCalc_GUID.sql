-- Function: zfCalc_GUID

DROP FUNCTION IF EXISTS zfCalc_GUID();

CREATE OR REPLACE FUNCTION zfCalc_GUID()
RETURNS TVarChar
-- RETURNS TABLE (vbGUID_seq Integer, RetV TVarChar, vbIndex Integer, vbIndex_two Integer, vbTest11 TVarChar, vbTest12 TVarChar, vbTest13 TVarChar, vbTest21 TVarChar, vbTest22 TVarChar, vbTest23 TVarChar)
AS
$BODY$
   DECLARE vbRetV      TVarChar;
   DECLARE vbIndex     Integer;
   DECLARE vbIndex_two Integer;
   DECLARE vbGUID_seq  Integer;

   DECLARE vbTest11     TVarChar;
   DECLARE vbTest12     TVarChar;
   DECLARE vbTest13     TVarChar;

   DECLARE vbTest21     TVarChar;
   DECLARE vbTest22     TVarChar;
   DECLARE vbTest23     TVarChar;
BEGIN
     -- ����
     vbGUID_seq:= NEXTVAL ('Movement_PromoCode_GUID_seq');
     
     -- ���������
     -- PERFORM pg_sleep (0.1);

     -- �������� ������
     vbRetV := SUBSTRING (md5 (CLOCK_TIMESTAMP() :: TVarChar || vbGUID_seq :: TVarChar) FROM 1 FOR 8);
     vbTest11:= vbRetV;
     
     -- ��� ����������� �������� < 100
     vbIndex     := 1;
     vbIndex_two := 1;

     -- ���� ���� ��� �������� ������ 2-�
     WHILE (zfCalc_CountDigit (vbRetV) >= 7 OR zfCalc_CountDigit (vbRetV) <= 2) AND vbIndex <= 100
     LOOP
         -- ���������
         PERFORM pg_sleep (0.3);

         -- �������� �������� ������
         vbRetV:= SUBSTRING (md5 (CLOCK_TIMESTAMP() :: TVarChar || vbGUID_seq :: TVarChar) FROM 1 FOR 8);
         IF vbIndex = 1   THEN vbTest12:= vbRetV; END IF;
         IF vbIndex = 100 THEN vbTest13:= vbRetV; END IF;
     
         -- ������ ��������� ��������
         vbIndex:= vbIndex + 1;

     END LOOP;

     -- ��������
     IF vbIndex >= 100
     THEN
         RAISE EXCEPTION '������. ����� 100 �������� �� �������� GUID � ������ ������� ���� � �������� <%> <%> <%>', vbTest11, vbTest12, vbTest13;
     END IF;

     
     -- ��������� 1 ��� �����-2
     vbTest21:= vbRetV;


     -- ���� ����� ������� - ����� �������� ���
     WHILE EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.DescId = zc_MIString_GUID() AND ValueData = vbRetV)
     LOOP
         -- ���������
         PERFORM pg_sleep (0.3);

         -- �������� �������� ������
         vbRetV:= SUBSTRING (md5 (CLOCK_TIMESTAMP() :: TVarChar || inNum) FROM 1 FOR 8);


         -- ��� ����������� �������� < 100
         -- vbIndex:= 1;

         -- ���� ���� ��� �������� ������ 2-�
         WHILE (zfCalc_CountDigit (vbRetV) >= 7 OR zfCalc_CountDigit (vbRetV) <= 2) AND vbIndex <= 100
         LOOP
             -- ���������
             PERFORM pg_sleep (0.3);
    
             -- �������� �������� ������
             vbRetV:= SUBSTRING (md5 (CLOCK_TIMESTAMP() :: TVarChar || vbGUID_seq :: TVarChar) FROM 1 FOR 8);
             IF vbIndex = 1   THEN vbTest12:= vbRetV; END IF;
             IF vbIndex = 100 THEN vbTest13:= vbRetV; END IF;
         
             -- ������ ��������� ��������
             vbIndex:= vbIndex + 1;
    
         END LOOP;

         -- ��������
         IF vbIndex >= 100
         THEN
             RAISE EXCEPTION '������. ����� 100 �������� �� �������� GUID � ������ ������� ���� � �������� <%> <%> <%>', vbTest11, vbTest12, vbTest13;
         END IF;


         -- ��������� 2+3 ��� �����-2
         IF vbIndex_two = 1   THEN vbTest22:= vbRetV; END IF;
         IF vbIndex_two = 100 THEN vbTest23:= vbRetV; END IF;


         -- ������ ��������� ��������
         vbIndex_two:= vbIndex_two + 1;

     END LOOP;
     

     -- ��������
     IF vbIndex_two >= 100
     THEN
         RAISE EXCEPTION '������. ����� 100 �������� �� �������� �������Ͳ� GUID <%> <%> <%>', vbTest21, vbTest22, vbTest23;
     END IF;


     -- ���������
     RETURN (vbRetV);
     
     -- ���������
     -- RETURN QUERY
     --   SELECT vbGUID_seq, vbRetV, vbIndex, vbIndex_two, vbTest11, vbTest12, vbTest13, vbTest21, vbTest22, vbTest23;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION zfCalc_UserSite () OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.17                                        *
*/

-- ����
-- SELECT zfCalc_GUID() FROM (SELECT GENERATE_SERIES (1, 10) AS Id) AS tmp ORDER BY Id
-- SELECT (SELECT tmp.RetV FROM zfCalc_GUID() AS tmp) As RetV FROM (SELECT GENERATE_SERIES (1, 10) AS Id) AS tmp ORDER BY Id
