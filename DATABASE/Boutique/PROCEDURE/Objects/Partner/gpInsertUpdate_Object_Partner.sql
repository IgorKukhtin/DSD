-- ��c�������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                       Integer   ,    -- ���� ������� <��c�������> 
 INOUT ioCode                     Integer,       -- ��� ������� <��c�������>  
    IN inBrandId                  Integer   ,    -- ���� ������� <�������� �����> 
    IN inFabrikaId                Integer   ,    -- ���� ������� <������� �������������> 
    IN inPeriodId                 Integer   ,    -- ���� ������� <������> 
    IN inPeriodYear               TFloat    ,    -- ��� �������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName   TVarChar;
   DECLARE vbOldId  Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������� ��������
   vbName:=    COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBrandId), '')
     || '-' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inPeriodId), '')
     || '-' || COALESCE ((inPeriodYear :: Integer) :: TVarChar, '');

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Partner_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Partner_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 


     -- �������� - ��� Sybase ������ Id
     IF vbUserId = zc_User_Sybase()
     THEN
       IF ioId > 0
       THEN
         vbOldId:= ioId;
         --
         ioId:= (SELECT Object.Id
                 FROM Object
                 WHERE Object.DescId    = zc_Object_Partner()
                   AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (vbName))
                 LIMIT 1
                );
         --
         UPDATE Object_PartionGoods SET PartnerId            = ioId
                                      , BrandId              = inBrandId
                                      , PeriodId             = inPeriodId
                                      , PeriodYear           = inPeriodYear
                                      , FabrikaId            = inFabrikaId
         WHERE Object_PartionGoods.PartnerId = vbOldId;
       ELSE
           ioId:= (SELECT Object.Id
                   FROM Object
                   WHERE Object.DescId    = zc_Object_Partner()
                     AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (vbName))
                  );
       END IF;

     END IF;


   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Partner(), vbName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), ioCode, vbName);

   -- ��������� <��� �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_PeriodYear(), ioId, inPeriodYear);

   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Brand(), ioId, inBrandId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Period(), ioId, inPeriodId);
   -- ��������� ����� � <������� �������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Fabrika(), ioId, inFabrikaId);


   -- !!!�������� �������� � ������!!!
   IF vbUserId <> zc_User_Sybase()
   THEN
       UPDATE Object_PartionGoods SET BrandId              = inBrandId
                                    , PeriodId             = inPeriodId
                                    , PeriodYear           = inPeriodYear
                                    , FabrikaId            = inFabrikaId
       WHERE Object_PartionGoods.PartnerId = ioId;
   END IF;


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
13.05.17                                                           *
08.05.17                                                           *
06.03.17                                                           *
27.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Partner()
