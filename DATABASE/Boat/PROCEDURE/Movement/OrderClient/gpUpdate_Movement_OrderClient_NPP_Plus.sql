-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_NPP_Plus (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_NPP_Plus(
    IN inId                  Integer   , -- ���� ������� <��������>
 INOUT ioNPP                 TFloat    , -- ����������� ������
    IN inIsPlus              Boolean   , -- ����������� ��� ��������� �������� NPP
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbNPP_old TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);

     -- �����
     vbNPP_old:= COALESCE ((SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_NPP()), 0);

     -- ������ ������ ��������
     IF inIsPlus = TRUE
     THEN -- ���� ��� ��� ������
          IF ioNPP = 0
          THEN -- ����� "�����" ���������
               ioNPP:= 1 + COALESCE ((SELECT MAX (MovementFloat.ValueData)
                                      FROM MovementFloat
                                           INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                                              AND Movement.DescId   = zc_Movement_OrderClient()
                                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                                      WHERE MovementFloat.DescId    = zc_MovementFloat_NPP()
                                        AND MovementFloat.ValueData > 0
                                     ), 0);
          -- ����� ������ �����
          ELSE ioNPP:= ioNPP + 1;
          END IF;

     ELSE
         -- ���� NPP ��� ���
         IF ioNPP >= 1
         THEN -- ������ ������
              ioNPP:= ioNPP - 1;
         ELSE
             -- ����� "�����" ���������
             ioNPP:= 1 + COALESCE ((SELECT MAX (MovementFloat.ValueData)
                                    FROM MovementFloat
                                         INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                                            AND Movement.DescId   = zc_Movement_OrderClient()
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    WHERE MovementFloat.DescId    = zc_MovementFloat_NPP()
                                      AND MovementFloat.ValueData > 0
                                   ), 0);
         END IF;

     END IF;


     -- ��������� ����� �������� <NPP>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), inId, ioNPP);

     -- ���� ���� = 0
     IF ioNPP = 0 AND vbNPP_old > 0
     THEN
         -- �.�. ��� 1-�, ������� ���� -1
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), MovementFloat.MovementId
                                               -- ��� ���� ��������������
                                             , MovementFloat.ValueData - 1
                                              )
         FROM MovementFloat
              INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                 AND Movement.DescId   = zc_Movement_OrderClient()
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementFloat.DescId     = zc_MovementFloat_NPP()
           AND MovementFloat.ValueData  > 1
           AND MovementFloat.MovementId <> inId
          ;

     -- ���� � "�����" NPP ���� ������, ����� ������ �� �������
     ELSEIF EXISTS (SELECT 1
                FROM MovementFloat
                WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                  AND MovementFloat.ValueData  = ioNPP
                  AND MovementFloat.MovementId <> inId
               )
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), MovementFloat.MovementId
                                             , COALESCE (MovementFloat.ValueData,0)
                                               -- ��� ������ �������
                                             + CASE WHEN inIsPlus = TRUE THEN -1 ELSE 1 END
                                              )
         FROM MovementFloat
             INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                AND Movement.DescId   = zc_Movement_OrderClient()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementFloat.DescId     = zc_MovementFloat_NPP()
           AND MovementFloat.ValueData  = ioNPP
           AND MovementFloat.MovementId <> inId
        ;

     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.02.23         *
*/

-- ����
--