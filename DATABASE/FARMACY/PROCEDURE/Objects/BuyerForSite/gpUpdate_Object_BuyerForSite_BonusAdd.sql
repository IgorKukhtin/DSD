-- Function: gpUpdate_Object_BuyerForSite_BonusAdd()

DROP FUNCTION IF EXISTS gpUpdate_Object_BuyerForSite_BonusAdd(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_BuyerForSite_BonusAdd(
    IN inId             Integer   ,     -- ���� ������� <����������> 
    IN inBonusAdd       TFloat    ,     -- ����� ������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_BuyerForSite());
      vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE(inId, 0) = 0
   THEN
     RETURN;   
   END IF;
         
   IF NOT EXISTS(SELECT 1 FROM ObjectFloat 
                 WHERE ObjectFloat.DescId = zc_ObjectFloat_BuyerForSite_BonusAdd()
                   AND ObjectFloat.ObjectId = inId
                   AND COALESCE(ObjectFloat.ValueData, 0) = COALESCE(inBonusAdd, 0))
   THEN
         
     -- ��������� �������
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BuyerForSite_BonusAdd(), inId, inBonusAdd);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   END IF;
      
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.09.22                                                       *
*/

-- ����  