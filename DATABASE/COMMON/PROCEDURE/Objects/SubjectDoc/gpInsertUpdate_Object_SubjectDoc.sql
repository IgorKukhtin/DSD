-- Function: gpInsertUpdate_Object_SubjectDoc()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc(Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SubjectDoc(
 INOUT ioId             Integer   ,     -- ���� ������� <�������> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inName           TVarChar  ,     -- �������� ������� 
    IN inShort          TVarChar  ,     -- ����������� ��������
    IN inReasonId       Integer   ,     -- ������� �������� / �����������
    IN inMovementDesc   TVarChar  , 
    IN inComment        TVarChar  ,
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_SubjectDoc());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SubjectDoc());
   
   -- �������� ���� ������������ ��� �������� <������������>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_SubjectDoc(), inName);
   IF EXISTS (SELECT Object.ValueData 
              FROM Object
                   LEFT JOIN ObjectLink AS ObjectLink_Reason
                                        ON ObjectLink_Reason.ObjectId = Object.Id 
                                       AND ObjectLink_Reason.DescId = zc_ObjectLink_SubjectDoc_Reason()
              WHERE Object.DescId = zc_Object_SubjectDoc() 
                AND TRIM (Object.ValueData) = TRIM (inName)
                AND Object.Id <> COALESCE(ioId, 0) 
                AND ((Object.ObjectCode < 1001 AND vbCode_calc < 1001) OR (Object.ObjectCode > 1001 AND vbCode_calc > 1000)) 
                AND COALESCE (inReasonId,0) = COALESCE (ObjectLink_Reason.ChildObjectId,0)
              )
   THEN
      RAISE EXCEPTION '�������� "%" �� ���������', inName;
   END IF; 

   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SubjectDoc(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SubjectDoc(), vbCode_calc, inName);


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SubjectDoc_Short(), ioId, inShort);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SubjectDoc_MovementDesc(), ioId, inMovementDesc);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SubjectDoc_Comment(), ioId, inComment);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SubjectDoc_Reason(), ioId, inReasonId);
   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.11.23         *
 06.02.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_SubjectDoc(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')
