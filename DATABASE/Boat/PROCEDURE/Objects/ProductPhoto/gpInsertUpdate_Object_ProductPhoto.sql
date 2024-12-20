-- Function: gpInsertUpdate_Object_ProductPhoto(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProductPhoto(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProductPhoto(
 INOUT ioId                        Integer   , -- ���� �������
    IN inPhotoName                 TVarChar  , --
    IN inProductId                 Integer   , --
    IN inProductPhotoData          TBlob     , -- ����
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

    -- ��������
   IF COALESCE (inProductId, 0) = 0
   THEN
       --RAISE EXCEPTION '������! ������� �� ����������!';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.����� �� �����������.'       :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_ProductPhoto' :: TVarChar
                                             , inUserId        := vbUserId
                                             );
   END IF;


   -- ���� �����
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') = '' 
   THEN
       -- ��������� �����
       ioId:= (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.ChildObjectId = inProductId AND OL.DescId = zc_ObjectLink_ProductPhoto_Product());
       --
     --inPhotoName:= 'https://agilis-jettenders.com/constructor-images/order-constructor-4754.png';
       inPhotoName:= 'order-constructor-'
                  || COALESCE ((SELECT Movement.InvNumber FROM MovementLinkObject AS MLO JOIN Movement ON Movement.Id = MLO.MovementId WHERE MLO.ObjectId = inProductId AND MLO.DescId = zc_MovementLinkObject_Product()
                               ), '???')
                  || '.png'
                    ;

   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ProductPhoto(), 0, inPhotoName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ProductPhoto_Data(), ioId, inProductPhotoData);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProductPhoto_Product(), ioId, inProductId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProductPhoto (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')

