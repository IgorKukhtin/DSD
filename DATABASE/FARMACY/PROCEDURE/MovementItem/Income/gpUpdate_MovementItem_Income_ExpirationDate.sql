DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_ExpirationDate(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_ExpirationDate(
    IN inMovementItemId      Integer   , -- ������ ���������
    IN inMovementId          Integer   , -- ��������
    IN inJuridicalId         Integer   , -- ���������
    IN inExpirationDate      TDateTime , -- ���� ��������
   OUT outExpirationDate     TDateTime , -- ���� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

--    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
--              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
--    THEN
--      RAISE EXCEPTION '������. � ��� ��� ���� ��������� ��� ��������.';     
--    END IF;     

    -- ������������
    SELECT 
        StatusId
      , InvNumber 
    INTO 
        vbStatusId
      , vbInvNumber   
    FROM 
        Movement 
    WHERE
        Id = inMovementId;
     
    --
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������. ��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF NOT EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_ChangeExpirationDate
                  WHERE ObjectBoolean_ChangeExpirationDate.ObjectId = inJuridicalId
                    AND ObjectBoolean_ChangeExpirationDate.DescId = zc_ObjectBoolean_Juridical_ChangeExpirationDate()
                    AND ObjectBoolean_ChangeExpirationDate.ValueData = TRUE)
    THEN
        RAISE EXCEPTION '������. �� ���������� ��������� �������� ���� ��������.';
    END IF;

    -- ��������� <���� ��������>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inMovementItemId, inExpirationDate);
    
    outExpirationDate := inExpirationDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.07.21                                                       *
*/

-- select * from gpUpdate_MovementItem_Income_ExpirationDate(inMovementItemId := 427266561 , inMovementId := 23186807 , inJuridicalId := 1311462 , inExpirationDate := ('07.07.2021')::TDateTime ,  inSession := '3');