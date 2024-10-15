-- Function: gpInsertUpdate_Object_ProductDocument_bySave(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProductDocument_bySave (Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProductDocument_bySave(
 INOUT ioId                        Integer   , -- ���� �������
    IN inDocumentName                  TVarChar  , -- �������� PDF
    IN inProductId                 Integer   , -- �������� ����
    IN inProductDocumentData                   TBlob     , -- ����
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
       RAISE EXCEPTION '������.�� ����������� �������� <Boat>.';
   END IF;

   -- ��������
   IF COALESCE (TRIM (inDocumentName), '') = '' 
   THEN 
       RAISE EXCEPTION '������.�� �������� ��� �����.';
   END IF;


   -- ������ ��������� �����
   ioId:= (SELECT Object_ProductDocument.Id        AS Id
           FROM Object AS Object_ProductDocument
                JOIN ObjectLink AS ObjectLink_ProductDocument_Product
                                ON ObjectLink_ProductDocument_Product.ObjectId = Object_ProductDocument.Id
                               AND ObjectLink_ProductDocument_Product.DescId = zc_ObjectLink_ProductDocument_Product()
                               AND ObjectLink_ProductDocument_Product.ChildObjectId = inProductId
           WHERE Object_ProductDocument.DescId = zc_Object_ProductDocument()
             AND TRIM (Object_ProductDocument.ValueData) = TRIM (inDocumentName)    --  � ����� ��������� PDF
          );

   -- ���������
   ioId :=  gpInsertUpdate_Object_ProductDocument (ioId                 := ioId
                                                 , inDocumentName       := inDocumentName
                                                 , inProductId          := inProductId
                                                 , inProductDocumentData:= inProductDocumentData
                                                 , inSession            := inSession
                                                  );  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.               
 14.10.24         *
*/

-- ����
--