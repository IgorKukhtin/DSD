-- Function: gpInsertUpdate_Object_InvoicePdf_bySave(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InvoicePdf_bySave (Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InvoicePdf_bySave(
 INOUT ioId                        Integer   , -- ���� �������
    IN inPhotoName                 TVarChar  , -- �������� PDF
    IN inMovementId                Integer   , -- �������� ����
    IN inInvoicePdfData            TBlob     , -- ����
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
   IF COALESCE (inMovementId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.�� ����������� �������� <�������� ����>.';
   END IF;

   -- ��������
   IF COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RAISE EXCEPTION '������.�� �������� ��� �����.';
   END IF;


   -- ������ ��������� �����
   ioId:= (SELECT OF_Id.ObjectId 
           FROM ObjectFloat AS OF_Id
                INNER JOIN Object AS Object_InvoicePdf 
                                  ON Object_InvoicePdf.Id        = OF_Id.ObjectId 
                                 AND Object_InvoicePdf.DescId    = zc_Object_InvoicePdf()
                                 --  � ����� ��������� PDF
                                 AND Object_InvoicePdf.ValueData = inPhotoName
           -- �������� ����
           WHERE OF_Id.ValueData = inMovementId :: TFloat
             AND OF_Id.DescId = zc_ObjectFloat_InvoicePdf_MovementId()
          );


   -- ���������
   ioId :=  gpInsertUpdate_Object_InvoicePdf (ioId                 := ioId
                                            , inPhotoName          := inPhotoName
                                            , inMovementId         := inMovementId
                                            , inInvoicePdfData     := inInvoicePdfData
                                            , inSession            := inSession
                                             );  
                                            

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.               
 26.02.24         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_InvoicePdf_bySave (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')