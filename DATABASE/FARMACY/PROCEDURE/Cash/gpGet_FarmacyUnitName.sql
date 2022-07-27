-- Function: gpGet_FarmacyUnitName()

DROP FUNCTION IF EXISTS gpGet_FarmacyUnitName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_FarmacyUnitName(
    OUT    outUnitCode        Integer , --
    OUT    outUnitName        TVarChar, -- ��� ������ ��� ������� ������ ������������
    IN     inUnitCode         Integer,  -- ��� ������ ��� ������� ������ ������������
    IN     inSession          TVarChar  -- ������ ������������
)
RETURNS record AS
$body$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId_find Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpGetUserBySession (inSession);

    -- �������� ������
   IF COALESCE(inUnitCode, 0) = 0
   THEN
       RAISE EXCEPTION '������.��� ������ �� ����� ���� ������.';
   END IF;

   IF 1 < (SELECT COUNT(*) FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode = inUnitCode AND isErased = FALSE)
   THEN
       RAISE EXCEPTION '������.��� <%> ��������� � ���������� �����.', inUnitCode;
   ELSE
       -- ����� �� ����
       vbUnitId_find:= (SELECT Id FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode = inUnitCode AND isErased = FALSE);
       -- �������� ������
       IF COALESCE (vbUnitId_find, 0) = 0
       THEN
           RAISE EXCEPTION '������.��� ������ <%> �� ������.', inUnitCode;
       END IF;
   END IF;

   -- �������
   SELECT Object.ObjectCode, Object.ValueData
   INTO outUnitCode, outUnitName
   FROM Object 
   WHERE Object.DescId = zc_Object_Unit() 
     AND Object.ID = COALESCE (vbUnitId_find, 0);
    


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.02.20                                                       *
*/

-- ����
--
 SELECT * FROM gpGet_FarmacyUnitName (inUnitCode := 18, inSession:= zfCalc_UserAdmin());
