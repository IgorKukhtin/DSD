-- Function: gpInsertUpdate_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDI_Send (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDI_Send(
 INOUT ioId                    Integer    , -- ���� ������� <�������� ��� �������� � EDI>
    IN inParentId              Integer    , -- �������� - ������� ����������
    IN inDescCode              TVarChar  , --
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbIsInsert     Boolean;
   DECLARE vbDescId       Integer;
   DECLARE vbJuridicalId  Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- �����
     vbDescId := (SELECT Id FROM MovementBooleanDesc WHERE Code ILIKE inDescCode);
     -- ��������
     IF COALESCE (vbDescId, 0) = 0 THEN
         RAISE EXCEPTION '������.������� �������� ��-�� <��� ��������> = <%>.', inDescCode;
     END IF;


     -- �����
     ioId:=  (SELECT Movement.Id
              FROM Movement
                   INNER JOIN MovementBoolean ON MovementBoolean.MovementId = Movement.Id
                                             AND MovementBoolean.DescId     = vbDescId
                                             AND MovementBoolean.ValueData  = TRUE
              WHERE Movement.ParentId = inParentId
                AND Movement.DescId   = zc_Movement_EDI_Send()
             );


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     IF ioId > 0
     THEN
         -- ������� ������, �� �������� - ������ �� ���������
         UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete(), StatusId_next = zc_Enum_Status_UnComplete() WHERE Id = ioId AND StatusId <> zc_Enum_Status_UnComplete();

         -- ��������� �������� <����/����� ���������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);

     ELSE
         -- ��������� <��������>
         ioId := lpInsertUpdate_Movement (ioId, zc_Movement_EDI_Send(), CAST (NEXTVAL (LOWER ('Movement_EDI_Send_seq')) AS TVarChar) , CURRENT_TIMESTAMP, inParentId);

         -- ��������� �������� <��� ��������> - ������ ���� �� ��-� ����� ���������, �.�. ��� ������ �������� ����� ��������� ������
         PERFORM lpInsertUpdate_MovementBoolean (vbDescId, ioId, TRUE);

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);
     
     
     -- ��� ����� ���� ����� ������, ���� Desadv
     IF EXISTS (SELECT 1 FROM MovementBooleanDesc WHERE Code ILIKE inDescCode AND Id = zc_MovementBoolean_EdiDesadv())
     THEN
         -- �� �������
         vbJuridicalId:= (SELECT ObjectLink_Partner_Juridical.ChildObjectId
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          WHERE Movement.Id = inParentId
                         );

         -- ���� ����� Vchasno - EDI
         IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbJuridicalId AND OB.DescId = zc_ObjectBoolean_Juridical_VchasnoEdi() AND OB.ValueData = TRUE)
         -- ���� �������
         --AND NOT EXISTS (SELECT 1
         --                FROM ObjectLink AS OL
         --                WHERE OL.ObjectId  = vbJuridicalId AND OL.DescId = zc_ObjectLink_Juridical_Retail()
         --                  AND OL.ChildObjectId IN (8873723 -- �����
         --                                          )
         --               )
         THEN
             -- ���� Delnot
             IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbJuridicalId AND OB.DescId = zc_ObjectBoolean_Juridical_isEdiDelnot() AND OB.ValueData = TRUE)
             THEN
                 -- �������� �������� Delnot
                 PERFORM gpInsertUpdate_Movement_EDI_Send (ioId       := 0
                                                         , inParentId := inParentId
                                                         , inDescCode := 'zc_MovementBoolean_EdiDelnot'
                                                         , inSession  := inSession
                                                          );
             END IF;

             -- ���� Comdoc
             IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbJuridicalId AND OB.DescId = zc_ObjectBoolean_Juridical_isEdiComdoc() AND OB.ValueData = TRUE)
             THEN
                 -- �������� �������� Comdoc
                 PERFORM gpInsertUpdate_Movement_EDI_Send (ioId       := 0
                                                         , inParentId := inParentId
                                                         , inDescCode := 'zc_MovementBoolean_EdiComdoc'
                                                         , inSession  := inSession
                                                          );
             END IF;

         END IF; -- ���� ����� Vchasno - EDI

     END IF; -- ���� Desadv

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.02.18                                        *

*/
-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EDI_Send (ioId:= 0, inParentId:= 1, inDescCode:= '', inSession:= '2')
