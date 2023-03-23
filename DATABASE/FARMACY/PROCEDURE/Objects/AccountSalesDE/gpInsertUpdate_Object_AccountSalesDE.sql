DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AccountSalesDE (Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AccountSalesDE(
    IN inMovementItemContainerId Integer    , -- ID �������� �� ���������� MovementItemContainer
    IN inActNumber               TVarChar   , -- ����� ����
    IN inAmount                  TFloat     , -- ����� ����
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbId       Integer;
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpGetUserBySession(inSession);

   IF COALESCE (inMovementItemContainerId, 0) = 0 
   THEN
       RAISE EXCEPTION '�� ������� ID �������� �� ����������';
   END IF;
    
   SELECT Object.Id
   INTO vbId
   FROM Object
   WHERE Object.DescId = zc_Object_AccountSalesDE()
     AND Object.ObjectCode = inMovementItemContainerId;
   
   -- ���������� <�������>
   vbIsUpdate:= COALESCE (vbId, 0) > 0;

   -- ��������� <������>
   vbId := lpInsertUpdate_Object (vbId, zc_Object_AccountSalesDE(), inMovementItemContainerId, inActNumber);
   
   -- ��������� ����� � <������� �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_AccountSalesDE_Amount(), vbId, inAmount);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= vbId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AccountSalesDE (Integer, TVarChar, TFloat, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 11.10.15                                                          *
*/