-- Function: gpUpdate_Movement_INN()
DROP FUNCTION IF EXISTS gpUpdate_Movement_INN (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_INN(
    IN inMovementId          Integer   , -- ���� ������� <��������>
 INOUT ioINN                 TVarChar  , --
   OUT outisINN              Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
BEGIN
    -- �������
    vbDescId := (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);


     -- ��������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_UnComplete())
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , lfGet_Object_ValueData ((SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId));
     END IF;


    IF COALESCE (ioINN, '') <> ''
    THEN
        outisINN := TRUE;
    ELSE
        outisINN := FALSE;
    END IF;


    IF vbDescId = zc_Movement_Tax()
    THEN
        -- �������� ���� ������������ �� ����� ���������
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());

        -- ��������� <>
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_ToINN(), inMovementId, ioINN);
        
        --
        IF ioINN = '' THEN
          ioINN:= (SELECT ObjectHistory_JuridicalDetails_View.OKPO FROM MovementLinkObject AS MLO LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());
        END IF;
            

    ELSEIF vbDescId = zc_Movement_TaxCorrective()
    THEN
        -- �������� ���� ������������ �� ����� ���������
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

        -- ��������� <>
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_FromINN(), inMovementId, ioINN);

        --
        IF ioINN = '' THEN
          ioINN:= (SELECT ObjectHistory_JuridicalDetails_View.OKPO FROM MovementLinkObject AS MLO LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
        END IF;

    ELSE
        RAISE EXCEPTION '������.��� ��������� <%>', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = vbDescId);

    END IF;


    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.03.18         *
*/

-- ����
--