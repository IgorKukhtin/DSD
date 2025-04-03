-- Function: gpInsert_ScaleCeh_Movement_all()

DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_Movement_all (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleCeh_Movement_all(
    IN inBranchCode          Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId_begin    Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId_find  Integer;
   DECLARE vbMovementId_begin Integer;
   DECLARE vbMovementDescId   Integer;
   DECLARE vbUnitId           Integer;
   
   DECLARE vbId_tmp Integer;
   DECLARE vbGoodsId_ReWork Integer;
   DECLARE vbDocumentKindId Integer;
   DECLARE vbPartionGoods   TVarChar;
   DECLARE vbPartionGoods_partner TVarChar;
   DECLARE vbIsProductionIn Boolean;
   DECLARE vbIsReWork Boolean;
   DECLARE vbWeighingNumber TFloat;

   DECLARE vbIsUpak_UnComplete Boolean;
   DECLARE vbIsCloseInventory  Boolean;
   DECLARE vbIsRePack          Boolean;
   DECLARE vbIsAuto            Boolean;

   DECLARE vbOperDate_invent TDateTime;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ScaleCeh_Movement_all());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ ��� ���������.';
     END IF;

     --
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpScale_receipt'))
     THEN
         DELETE FROM _tmpScale_receipt;
     ELSE
         CREATE TEMP TABLE _tmpScale_receipt (GoodsId_from Integer, GoodsId_to Integer, GoodsKindId_to Integer) ON COMMIT DROP;
     END IF;


     -- ���������� <��� ���������>
     vbMovementDescId:= (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_MovementDesc()) :: Integer;
     -- ���������� <��������������>
     vbIsAuto:= (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_isAuto());
     -- ����������
     vbUnitId:= (SELECT CASE -- ����������� = ��
                             WHEN vbMovementDescId IN (zc_Movement_Inventory(), zc_Movement_Loss())
                                  THEN MLO_From.ObjectId
                             -- ����������� = ��
                             WHEN vbMovementDescId IN (zc_Movement_Send()) AND MLO_From.ObjectId = zc_Unit_RK()
                                  THEN MLO_From.ObjectId
                             -- ���������� = ��, ��� ��������
                             WHEN vbMovementDescId IN (zc_Movement_Send()) AND MLO_From.ObjectId <> zc_Unit_Pack() AND MLO_To.ObjectId = zc_Unit_RK()
                                  THEN MLO_To.ObjectId
                             -- ���������� = ��
                             WHEN vbMovementDescId IN (zc_Movement_SendOnPrice()) AND MLO_To.ObjectId = zc_Unit_RK()
                                  THEN MLO_To.ObjectId
                             ELSE 0
                        END
                 FROM MovementLinkObject AS MLO_From
                      LEFT JOIN MovementLinkObject AS MLO_To
                                                   ON MLO_To.MovementId = inMovementId
                                                  AND MLO_To.DescId     = zc_MovementLinkObject_To()
                 WHERE MLO_From.MovementId = inMovementId
                   AND MLO_From.DescId     = zc_MovementLinkObject_From()
                );

     -- !!!���������� �������� - isRePack !!!
     IF vbMovementDescId = zc_Movement_Send()
     THEN
         vbIsRePack:= (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
                               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                                     , inLevel2      := 'Movement'
                                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                                     , inItemName    := 'isRePack'
                                                                     , inDefaultValue:= 'FALSE'
                                                                     , inSession     := inSession
                                                                      ) AS RetV
                                     FROM MovementFloat
                                     WHERE MovementFloat.MovementId = inMovementId
                                       AND MovementFloat.DescId     = zc_MovementFloat_MovementDescNumber()
                                       AND MovementFloat.ValueData  > 0
                                    ) AS tmp
                              );
         IF COALESCE (vbIsRePack, FALSE) = FALSE
         THEN
             vbIsRePack:= EXISTS (SELECT 1
                                  FROM MovementLinkObject AS MLO_From
                                       INNER JOIN MovementLinkObject AS MLO_To
                                                                     ON MLO_To.MovementId = inMovementId
                                                                    AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                    AND MLO_To.ObjectId   = zc_Unit_RK()
                                  WHERE MLO_From.MovementId = inMovementId
                                    AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                    AND MLO_From.ObjectId   IN (8462    -- ����� ����
                                                              , 9558031 -- ����� ��������
                                                               )
                                 );
         END IF;

      END IF;

     -- !!!���������� ��������!!!
     IF vbMovementDescId = zc_Movement_Inventory()
     THEN
         vbIsCloseInventory:= (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
                               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                                     , inLevel2      := 'Movement'
                                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                                     , inItemName    := 'isCloseInventory'
                                                                     , inDefaultValue:= 'TRUE'
                                                                     , inSession     := inSession
                                                                      ) AS RetV
                                     FROM MovementFloat
                                     WHERE MovementFloat.MovementId = inMovementId
                                       AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                       AND MovementFloat.ValueData > 0
                                    ) AS tmp
                              );
      END IF;

     -- ���������� <�����������>
     vbGoodsId_ReWork:= (SELECT CASE WHEN TRIM (tmp.RetV) = '' THEN '0' ELSE TRIM (tmp.RetV) END :: Integer
                         FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                               , inLevel2      := 'Movement'
                                                               , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                               , inItemName    := 'GoodsId_ReWork'
                                                               , inDefaultValue:= '0'
                                                               , inSession     := inSession
                                                                ) AS RetV
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId = inMovementId
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                 AND MovementFloat.ValueData > 0
                              ) AS tmp
                        );

     -- ���������� <��� ���������>
     vbDocumentKindId:= (SELECT CASE WHEN TRIM (tmp.RetV) = '' THEN '0' ELSE TRIM (tmp.RetV) END :: Integer
                         FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                               , inLevel2      := 'Movement'
                                                               , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                               , inItemName    := 'DocumentKindId'
                                                               , inDefaultValue:= '0'
                                                               , inSession     := inSession
                                                                ) AS RetV
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId = inMovementId
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                 AND MovementFloat.ValueData > 0
                              ) AS tmp
                        );
     -- ���������� <������ ������>
     vbPartionGoods:= (SELECT DISTINCT MIString_PartionGoods.ValueData
                       FROM MovementItem
                            INNER JOIN MovementItemString AS MIString_PartionGoods
                                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                         AND MIString_PartionGoods.ValueData <> ''
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.isErased = FALSE
                         AND vbMovementDescId = zc_Movement_ProductionSeparate()
                      );

     -- !!!�������� ��������!!! : ����������� -> ������������ �����������
     IF vbMovementDescId = zc_Movement_Send() AND (vbGoodsId_ReWork > 0
                                                /*OR (-- ���� ����� "�� ����"
                                                  (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                  IN (SELECT 8451 -- ��� ��������
                                                     UNION
                                                      SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8453) AS lfSelect -- ������
                                                     )
                                              AND -- ���� ����� "����"
                                                  (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                  IN (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId <> 8450 -- ��� �������+���-�� <> ��� ��������
                                                     UNION
                                                      SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8439) AS lfSelect -- ������� ������� �����
                                                     )
                                              AND -- ���� ��� �� ����������� �����������
                                                  NOT EXISTS
                                                  (SELECT MovementItem.MovementId
                                                   FROM MovementItem
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30301() -- ������ + ����������� + �����������
                                                  ))*/)
     THEN
         -- ��������
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                               ON ObjectLink_Goods_InfoMoney.ObjectId      = MovementItem.ObjectId
                                              AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                              AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() -- ��������� ����
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSe
                   )
         THEN
             RAISE EXCEPTION '������.� �������� �� ����� ����������� ������ � �� = <%>', lfGet_Object_ValueData_sh (zc_Enum_InfoMoney_20501());
         END IF;
         --
         vbMovementDescId:= zc_Movement_ProductionUnion();
         vbIsReWork:= TRUE;
         vbIsProductionIn:= TRUE;
     ELSE
         vbIsReWork:= FALSE;
         IF vbDocumentKindId = zc_Enum_DocumentKind_PackDiff()
         THEN
             -- ���������� <������ ��� ������>
             vbIsProductionIn:= (SELECT MB_isIncome.ValueData FROM MovementBoolean AS MB_isIncome WHERE MB_isIncome.MovementId = inMovementId AND MB_isIncome.DescId = zc_MovementBoolean_isIncome());
         ELSE
             -- �������
             vbIsProductionIn:= TRUE;
         END IF;
     END IF;


     -- ����� � ���������� - �������� ����� �� ��������
     vbIsUpak_UnComplete:= EXISTS (SELECT 1
                                   FROM Object_Unit_Scale_upak_View
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = inMovementId
                                                                         AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                                         AND MovementLinkObject_From.ObjectId   = Object_Unit_Scale_upak_View.FromId
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = inMovementId
                                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId   = Object_Unit_Scale_upak_View.ToId
                                  );


     -- ��� zc_Movement_ProductionUnion + ���� zc_Enum_DocumentKind_PackDiff
     IF vbMovementDescId = zc_Movement_ProductionUnion() AND vbDocumentKindId = zc_Enum_DocumentKind_PackDiff()
     THEN
           -- ����� ������������� ��������� <������������> �� ���� ����������
           vbMovementId_find:= (SELECT Movement.Id
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                                                   ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                                                  AND MovementLinkObject_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
                                                                  AND MovementLinkObject_DocumentKind.ObjectId   = zc_Enum_DocumentKind_PackDiff()
                                WHERE Movement.DescId = zc_Movement_ProductionUnion()
                                  AND Movement.OperDate = inOperDate
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                LIMIT 1 -- !!!���������� - ����� �� ����!!!
                               );
            vbWeighingNumber:= 1 + COALESCE ((SELECT COUNT(*) FROM Movement WHERE ParentId = vbMovementId_find AND DescId = zc_Movement_WeighingProduction() AND StatusId <> zc_Enum_Status_Erased()), 0);
     END IF;


     -- ��� zc_Movement_ProductionUnion + ���� ������� - !!!����� �.�. ������ ��� �������� ���� �����-�� ������ ����� ....!!!
     IF 1=0 AND vbMovementDescId = zc_Movement_ProductionUnion() AND inBranchCode BETWEEN 201 AND 210 -- ���� �������
     THEN
           -- ���������� <������ ��� ������>, ����� ��� �������
           vbIsProductionIn:= (SELECT MB_isIncome.ValueData FROM MovementBoolean AS MB_isIncome WHERE MB_isIncome.MovementId = inMovementId AND MB_isIncome.DescId = zc_MovementBoolean_isIncome());

           -- ����� ������������� ��������� <������������> �� ���� ����������
           vbMovementId_find:= (SELECT Movement.Id
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                WHERE Movement.DescId = zc_Movement_ProductionUnion()
                                  AND Movement.OperDate = inOperDate
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()));
            vbWeighingNumber:= 1 + COALESCE ((SELECT COUNT(*) FROM Movement WHERE ParentId = vbMovementId_find AND DescId = zc_Movement_WeighingProduction() AND StatusId <> zc_Enum_Status_Erased()), 0);
     END IF;

     -- ��� zc_Movement_ProductionSeparate
     IF vbMovementDescId = zc_Movement_ProductionSeparate()
     THEN
           -- ������ ��� ������� �����
           IF 8442 = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
          AND 8442 = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
          AND 1=0
           THEN
               -- ���������� <������ ������> - ��� ����������
               vbPartionGoods_partner:= zfFormat_PartionGoods (vbPartionGoods);
           END IF;

           -- ���������� <������ ��� ������>, ����� ��� zc_Movement_ProductionSeparate
           vbIsProductionIn:= (SELECT MB_isIncome.ValueData FROM MovementBoolean AS MB_isIncome WHERE MB_isIncome.MovementId = inMovementId AND MB_isIncome.DescId = zc_MovementBoolean_isIncome());

           -- ��������
           IF 1 <              (SELECT COUNT (*)
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                     INNER JOIN MovementString AS MovementString_PartionGoods
                                                               ON MovementString_PartionGoods.MovementId = Movement.Id
                                                              AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                              AND MovementString_PartionGoods.ValueData = vbPartionGoods
                                WHERE Movement.DescId = zc_Movement_ProductionSeparate()
                                  AND Movement.OperDate = inOperDate
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()))
           THEN
               RAISE EXCEPTION '������.��� ������ <%> ������� ��� ��������� � <%> � � <%> �� <%>. � ������ ���� ������ ����.'
                             , vbPartionGoods
                             , (SELECT Movement.InvNumber
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                     INNER JOIN MovementString AS MovementString_PartionGoods
                                                               ON MovementString_PartionGoods.MovementId = Movement.Id
                                                              AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                              AND MovementString_PartionGoods.ValueData = vbPartionGoods
                                WHERE Movement.DescId = zc_Movement_ProductionSeparate()
                                  AND Movement.OperDate = inOperDate
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                ORDER BY Movement.Id ASC
                                LIMIT 1
                               )
                             , (SELECT Movement.InvNumber
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                     INNER JOIN MovementString AS MovementString_PartionGoods
                                                               ON MovementString_PartionGoods.MovementId = Movement.Id
                                                              AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                              AND MovementString_PartionGoods.ValueData = vbPartionGoods
                                WHERE Movement.DescId = zc_Movement_ProductionSeparate()
                                  AND Movement.OperDate = inOperDate
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                ORDER BY Movement.Id DESC
                                LIMIT 1
                               )
                             , zfConvert_DateToString (inOperDate)
                              ;
           END IF;

           -- ����� ������������� ��������� <������������> �� ���� ���������� + ������
           vbMovementId_find:= (SELECT Movement.Id
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                     INNER JOIN MovementString AS MovementString_PartionGoods
                                                               ON MovementString_PartionGoods.MovementId = Movement.Id
                                                              AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                              AND MovementString_PartionGoods.ValueData = vbPartionGoods
                                WHERE Movement.DescId = zc_Movement_ProductionSeparate()
                                  AND Movement.OperDate = inOperDate
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()));
            vbWeighingNumber:= 1 + COALESCE ((SELECT COUNT(*) FROM Movement WHERE ParentId = vbMovementId_find AND DescId = zc_Movement_WeighingProduction() AND StatusId <> zc_Enum_Status_Erased()), 0);
     END IF;


     IF vbMovementDescId = zc_Movement_Inventory()
     THEN
         --!!!tmp
         -- IF vbUserId = 5 THEN inOperDate:= '29.02.2024'; END IF;

         -- ����������� ��������
         vbIsCloseInventory:= zc_Unit_RK() <> COALESCE ((SELECT MLO.ObjectId AS MLO FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From()), 0);
     END IF;

     -- ��� zc_Movement_Inventory
     IF vbMovementDescId = zc_Movement_Inventory()
     THEN
           -- ��������
           vbOperDate_invent:= (SELECT CASE WHEN inBranchCode = 102 AND MovementLinkObject_From.ObjectId IN (8447) -- ��� ���������
                                                 THEN inOperDate
                                            WHEN inBranchCode = 102 AND MovementLinkObject_From.ObjectId NOT IN (8447, 8448) -- ��� ��������� + ��� �����������
                                                 THEN inOperDate
                                            ELSE inOperDate - INTERVAL '1 DAY'
                                       END
                                FROM MovementLinkObject AS MovementLinkObject_From
                                WHERE MovementLinkObject_From.MovementId = inMovementId
                                  AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                               );
           -- ��������
           IF 1 <              (SELECT COUNT (*)
                                FROM (WITH tmpFind AS (SELECT MLO.ObjectId AS FromId
                                                       FROM MovementLinkObject AS MLO
                                                       WHERE MLO.MovementId = inMovementId
                                                         AND MLO.DescId     = zc_MovementLinkObject_From()
                                                      )
                                      --
                                      SELECT Movement.Id
                                      FROM Movement
                                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                           INNER JOIN tmpFind ON tmpFind.FromId = MovementLinkObject_From.ObjectId
                                      WHERE Movement.DescId   = zc_Movement_Inventory()
                                        AND Movement.OperDate = vbOperDate_invent
                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                     ) AS tmp
                               )
           THEN
               RAISE EXCEPTION '������.�� <%> ������� ��� ��������� �������������� � <%> � � <%>. � ������ ���� ������ ����.'
                             , zfConvert_DateToString (vbOperDate_invent)
                             , (SELECT Movement.InvNumber
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                WHERE Movement.DescId = zc_Movement_Inventory()
                                  AND Movement.OperDate = vbOperDate_invent
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                ORDER BY Movement.Id ASC
                                LIMIT 1
                               )
                             , (SELECT Movement.InvNumber
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                WHERE Movement.DescId = zc_Movement_Inventory()
                                  AND Movement.OperDate = vbOperDate_invent
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                ORDER BY Movement.Id DESC
                                LIMIT 1
                               )
                               ;
           END IF;

           -- ����� ������������� ��������� <��������������> �� ���� ����������
           vbMovementId_find:= (SELECT Movement.Id
                                FROM (WITH tmpFind AS (SELECT MLO.ObjectId AS FromId
                                                       FROM MovementLinkObject AS MLO
                                                       WHERE MLO.MovementId = inMovementId
                                                         AND MLO.DescId     = zc_MovementLinkObject_From()
                                                      )
                                      --
                                      SELECT Movement.Id
                                      FROM Movement
                                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                           INNER JOIN tmpFind ON tmpFind.FromId = MovementLinkObject_From.ObjectId
                                      WHERE Movement.DescId   = zc_Movement_Inventory()
                                        AND Movement.OperDate = vbOperDate_invent
                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                     ) AS Movement
                               );
     END IF;


     -- ���������
     vbMovementId_begin:= vbMovementId_find;


    -- ��������� <��������>
    IF COALESCE (vbMovementId_begin, 0) = 0
    THEN
        -- ���������
        vbMovementId_begin:= (SELECT CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion()
                                           AND vbDocumentKindId IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg())
                                                    -- !!!��� ���������!!!
                                               THEN 0
                                          WHEN vbMovementDescId = zc_Movement_Loss()
                                                    -- <��������>
                                               THEN lpInsertUpdate_Movement_Loss_scale
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Loss_seq') AS TVarChar)
                                                  , inOperDate              := CASE WHEN inBranchCode = 102 AND FromId IN (8448) -- ��� �����������
                                                                                         THEN inOperDate - INTERVAL '1 DAY'
                                                                                    ELSE inOperDate
                                                                               END
                                                  , inPriceWithVAT          := FALSE
                                                  , inVATPercent            := 20
                                                  , inFromId                := FromId
                                                  , inToId                  := NULL
                                                  , inArticleLossId         := ToId -- !!!�� ������!!!
                                                  , inPaidKindId            := zc_Enum_PaidKind_SecondForm()
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Send()
                                                    -- <�����������>
                                               THEN lpInsertUpdate_Movement_Send
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Send_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inDocumentKindId        := vbDocumentKindId
                                                  , inSubjectDocId          := SubjectDocId
                                                  , inComment               := tmp.Comment
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ProductionUnion()
                                                    -- <������ � ������������>
                                               THEN lpInsertUpdate_Movement_ProductionUnion
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inDocumentKindId        := vbDocumentKindId
                                                  , inIsPeresort            := FALSE
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ProductionSeparate()
                                                    -- <������������>
                                               THEN lpInsertUpdate_Movement_ProductionSeparate
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ProductionSeparate_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPartionGoods          := vbPartionGoods
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Inventory()
                                                    -- <��������������>
                                               THEN lpInsertUpdate_Movement_Inventory
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Inventory_seq') AS TVarChar)
                                                  , inOperDate              := CASE WHEN inBranchCode = 102 AND FromId IN (8447) -- ��� ���������
                                                                                         THEN inOperDate
                                                                                    WHEN inBranchCode = 102 AND FromId NOT IN (8447, 8448) -- ��� ��������� + ��� �����������
                                                                                         THEN inOperDate
                                                                                    ELSE inOperDate - INTERVAL '1 DAY'
                                                                               END
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inGoodsGroupId          := 0
                                                  , inPriceListId           := Null ::Integer
                                                  , inisGoodsGroupIn        := FALSE
                                                  , inisGoodsGroupExc       := FALSE
                                                  , inisList                := FALSE
                                                  , inUserId                := -1 * vbUserId
                                                   )

                                          END AS MovementId_begin

                                    FROM gpGet_Movement_WeighingProduction (inMovementId:= inMovementId, inSession:= inSession) AS tmp
                                 );

         -- �������� ��-��
         IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalGroup() AND MLO.ObjectId > 0)
         THEN
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalGroup(), vbMovementId_begin
                                                      , (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalGroup() AND MLO.ObjectId > 0)
                                                       );
         END IF;
         -- �������� ��-�� - �������������� ������ ��� ��������� �������
         IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_List() AND MB.ValueData = TRUE)
         THEN
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), vbMovementId_begin, TRUE);
         END IF;

         -- ��������� ����� � ���������� <������ ���������>
         IF vbMovementDescId = zc_Movement_Send() AND EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order() AND MLM.MovementChildId > 0)
         THEN
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), vbMovementId_begin
                                                        , (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order() AND MLM.MovementChildId > 0)
                                                         );
         END IF;

         -- ������ �� ��� <����������� �/� ���� �������>
         IF vbMovementDescId <> zc_Movement_ProductionUnion() OR vbDocumentKindId NOT IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg())
         THEN
             -- ��������
             IF COALESCE (vbMovementId_begin, 0) = 0
             THEN
                 RAISE EXCEPTION '������.������ ��������� ������ ��� ���������.';
             END IF;

            -- �������� ��-�� <����/����� ��������>
            PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId_begin, CURRENT_TIMESTAMP);
         END IF;

    ELSE
        -- ����������� �������� !!!������������!!!
        PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_begin
                                     , inUserId     := vbUserId);
    END IF;


     -- ������ ��� ������� ����� - ��������� ������
     IF vbPartionGoods_partner <> ''
     THEN
         -- <������ �� ������������ - Separate>
         PERFORM lpInsertUpdate_MI_ProductionSeparate_Master
                                                         (ioId                  := MovementItem.Id
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmpIncome.GoodsId
                                                        , inGoodsKindId         := MILinkObject_StorageLine.ObjectId
                                                        , inStorageLineId       := NULL
                                                        , inAmount              := tmpIncome.Amount
                                                        , inLiveWeight          := tmpIncome.LiveWeight
                                                        , inHeadCount           := tmpIncome.HeadCount
                                                        , inUserId              := vbUserId
                                                         )
         FROM (SELECT vbMovementId_begin AS MovementId) AS tmpMovement
              LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.isErased = FALSE
              LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                               ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                              AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
              LEFT JOIN (SELECT MAX (MovementItem.ObjectId)                      AS GoodsId
                              , SUM (MovementItem.Amount)                        AS Amount
                              , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))  AS HeadCount
                              , SUM (COALESCE (MIFloat_LiveWeight.ValueData, 0)) AS LiveWeight
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                           AND MovementLinkObject_To.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From()) -- !!!�� ������!!!
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              INNER JOIN MovementItemString AS MIString_PartionGoodsCalc
                                                            ON MIString_PartionGoodsCalc.MovementItemId =  MovementItem.Id
                                                           AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()
                                                           AND MIString_PartionGoodsCalc.ValueData = vbPartionGoods_partner
                              /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()*/
                              LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                          ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                         AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                              LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                          ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                         AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                         WHERE Movement.DescId = zc_Movement_Income()
                           AND Movement.OperDate = inOperDate
                           AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                        ) AS tmpIncome ON 1 = 1
                       ;

     END IF;

     -- ������������ ������ ��� "�����������" Master ��� ������ �� ������������
     IF vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
     THEN
         IF vbDocumentKindId = zc_Enum_DocumentKind_PackDiff()
         THEN
             INSERT INTO _tmpScale_receipt (GoodsId_from, GoodsId_to, GoodsKindId_to)
                SELECT DISTINCT
                       MovementItem.ObjectId                           AS GoodsId_from
                     , ObjectLink_DocumentKind_Goods.ChildObjectId     AS GoodsId_to
                     , ObjectLink_DocumentKind_GoodsKind.ChildObjectId AS GoodsKindId_to
                FROM MovementItem
                     INNER JOIN ObjectLink AS ObjectLink_DocumentKind_Goods
                                           ON ObjectLink_DocumentKind_Goods.ObjectId = vbDocumentKindId
                                          AND ObjectLink_DocumentKind_Goods.DescId   = zc_ObjectLink_DocumentKind_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_DocumentKind_GoodsKind
                                           ON ObjectLink_DocumentKind_GoodsKind.ObjectId = vbDocumentKindId
                                          AND ObjectLink_DocumentKind_GoodsKind.DescId   = zc_ObjectLink_DocumentKind_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE;
         ELSE
             INSERT INTO _tmpScale_receipt (GoodsId_from, GoodsId_to)
                SELECT MovementItem.ObjectId                        AS GoodsId_from
                     , MAX (ObjectLink_Receipt_Goods.ChildObjectId) AS GoodsId_to
                FROM MovementItem
                     INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                           ON ObjectLink_ReceiptChild_Goods.ChildObjectId = MovementItem.ObjectId
                                          AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                           ON ObjectLink_ReceiptChild_Receipt.ObjectId = ObjectLink_ReceiptChild_Goods.ObjectId
                                          AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                     INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                              ON ObjectBoolean_Main.ObjectId = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                                             AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                             AND ObjectBoolean_Main.ValueData = TRUE
                     INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                           ON ObjectLink_Receipt_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                                          AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                     INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId AND Object_Receipt.isErased = FALSE
                     INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Goods.ObjectId AND Object_ReceiptChild.isErased = FALSE
                     LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                          ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                                         AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND ObjectLink_Receipt_GoodsKind.ChildObjectId IS NULL
                GROUP BY MovementItem.ObjectId
               ;
         END IF;
     END IF;

     -- ��������� <�������� �����>
     SELECT MAX (tmpId) INTO vbId_tmp
     FROM (-- �������� ��������� (���� ��������� ������)
           WITH tmpMI AS
                     (SELECT MovementItem.Id                                     AS MovementItemId
                           , MovementItem.ObjectId                               AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       -- ����� ���������� + ����� ���� ��
                                 --AND MLO_From.ObjectId IN (8459, 8458)
                                       THEN 0
                                  ELSE COALESCE (MILinkObject_StorageLine.ObjectId, 0)
                             END AS StorageLineId

                           , COALESCE (MILinkObject_Asset.ObjectId, 0)                AS AssetId
                           , COALESCE (MILinkObject_Asset_two.ObjectId, 0)            AS AssetId_two
                         --, COALESCE (MIFloat_PartionCell.ValueData, 0)   :: Integer AS PartionCellId
                           , 0   :: Integer AS PartionCellId

                           , CASE
                                  WHEN vbUnitId = zc_Unit_RK() -- ����������� ��������
                                       AND 1=1
                                       --AND vbUserId = 5 -- !!!tmp
                                       THEN COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())

                                  WHEN vbMovementDescId = zc_Movement_Inventory()
                                       -- ����� ���������� + ����� ���� ��
                                   AND MLO_From.ObjectId IN (zc_Unit_RK(), 8458)
                                       THEN NULL
                                  ELSE MIDate_PartionGoods.ValueData
                             END AS PartionGoodsDate

                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       -- ����� ���������� + ����� ���� ��
                                   AND MLO_From.ObjectId IN (zc_Unit_RK(), 8458)
                                       THEN ''
                                  ELSE COALESCE (MIString_PartionGoods.ValueData, '')
                             END AS PartionGoods

                           , COALESCE (MIString_PartNumber.ValueData, '')        AS PartNumber
                           , MovementItem.Amount                                 AS Amount
                           , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                           , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight

                           , 0                                                   AS Amount_mi
                           , 0                                                   AS myId

                           , 0                                                   AS MovementItemId_Partion

                             --  � �/�
                           , ROW_NUMBER() OVER (PARTITION BY -- ����� ���������� + ����� ���� ��
                                                             CASE WHEN vbMovementDescId = zc_Movement_Inventory() AND MLO_From.ObjectId IN (zc_Unit_RK(), 8458) THEN 0 ELSE MovementItem.Id END
                                                           , MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId
                                                           , CASE WHEN vbUnitId = zc_Unit_RK()
                                                                   AND 1=1
                                                                       THEN COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                                                                  ELSE zc_DateStart()
                                                             END
                                                ORDER BY MovementItem.Amount DESC) AS Ord

                      FROM (SELECT zc_MI_Master() AS DescId, 0 AS Amount WHERE vbMovementDescId = zc_Movement_Inventory()
                           UNION
                            SELECT zc_MI_Master() AS DescId, -1 AS Amount WHERE vbMovementDescId = zc_Movement_ProductionUnion()
                           UNION
                            SELECT zc_MI_Master() AS DescId, 0 AS Amount WHERE vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = FALSE AND 1 = 0 -- ���� �� ���� �����������
                           UNION
                            SELECT zc_MI_Child() AS DescId, 0 AS Amount WHERE vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = TRUE AND 1 = 0 -- ���� �� ���� �����������
                           ) AS tmp
                           INNER JOIN MovementItem ON MovementItem.MovementId = vbMovementId_find
                                                  AND MovementItem.DescId     = tmp.DescId
                                                  AND MovementItem.isErased   = FALSE
                                                  AND MovementItem.Amount <> tmp.Amount
                           LEFT JOIN MovementLinkObject AS MLO_From
                                                        ON MLO_From.MovementId = vbMovementId_find
                                                       AND MLO_From.DescId     = zc_MovementLinkObject_From()
                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                            ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                            ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                            ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
                           LEFT JOIN MovementItemFloat AS MIFloat_PartionCell
                                                       ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()

                    )

 , tmpMI_ScaleCeh AS (SELECT 0 AS MovementItemId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsReWork = TRUE
                                       THEN CASE WHEN vbGoodsId_ReWork > 0 THEN vbGoodsId_ReWork ELSE zc_Goods_ReWork() END

                                  WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()
                                       THEN _tmpScale_receipt.GoodsId_to

                                  ELSE MovementItem.ObjectId
                             END AS GoodsId

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsReWork = TRUE
                                       THEN zc_GoodsKind_Basis() -- NULL

                                  WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()
                                       THEN COALESCE (_tmpScale_receipt.GoodsKindId_to, 0)

                                  ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                             END AS GoodsKindId

                           , COALESCE (MILinkObject_StorageLine.ObjectId, 0) AS StorageLineId

                           , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                           , COALESCE (MILinkObject_Asset_two.ObjectId, 0)   AS AssetId_two

                           , 0 :: Integer AS PartionCellId

                           , COALESCE (MIString_PartNumber.ValueData, '')    AS PartNumber

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsReWork = TRUE
                                       THEN NULL
                                  WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()
                                       THEN NULL
                                  WHEN vbUnitId = zc_Unit_RK() -- ����������� ��������
                                       AND 1=1
                                       --AND vbUserId <> 5 -- !!!tmp
                                       THEN COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())

                                  ELSE MIDate_PartionGoods.ValueData
                             END AS PartionGoodsDate

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsReWork = TRUE
                                       THEN NULL
                                  WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()
                                       THEN ''
                                  ELSE COALESCE (MIString_PartionGoods.ValueData, '')
                             END AS PartionGoods

                           , CASE WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbDocumentKindId = zc_Enum_DocumentKind_PackDiff()
                                       THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                  WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()
                                       THEN 0
                                  ELSE MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                             END AS Amount -- !!! ��� ������ ��� ����������� � �����������!!
                           , CASE WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()

                                       THEN 0
                                  ELSE COALESCE (MIFloat_Count.ValueData, 0)
                             END AS Count
                           , CASE WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()
                                       THEN 0
                                  ELSE COALESCE (MIFloat_CountPack.ValueData, 0)
                             END AS CountPack
                           , CASE WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()
                                       THEN 0
                                  ELSE COALESCE (MIFloat_HeadCount.ValueData, 0)
                             END AS HeadCount
                           , CASE WHEN vbIsProductionIn = FALSE AND vbMovementDescId = zc_Movement_ProductionUnion()
                                       THEN 0
                                  ELSE COALESCE (MIFloat_LiveWeight.ValueData, 0)
                             END AS LiveWeight

                           , MovementItem.Amount AS Amount_mi
                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       THEN 0 -- ���� �����������

                                  WHEN inBranchCode = 101 -- ���� ��������
                                   AND vbMovementDescId = zc_Movement_Send()
                                       THEN MovementItem.Id -- �� ���� �����������

                                  WHEN inBranchCode BETWEEN 201 AND 210 -- ���� �������
                                   AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsReWork = TRUE
                                       THEN 0 -- ���� �����������

                                  WHEN inBranchCode NOT BETWEEN 201 AND 210 -- ���� �� �������
                                       THEN 0 -- ����� �����������
                                  -- !!!����� �.�. ������ ��� �������� ���� �����-�� ������ ����� ....!!!
                                  -- WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND inBranchCode BETWEEN 201 AND 210 -- ���� �������
                                  --      THEN 0 -- ���� �����������
                                  ELSE MovementItem.Id -- ���� �� ���� �����������
                             END AS myId
                             
                             -- ����� ���� ����� ����� ��� ��������������
                           , CASE WHEN vbUnitId = zc_Unit_RK() AND vbMovementDescId = zc_Movement_Inventory()
                                   AND inBranchCode = 1
                                   AND vbIsAuto = TRUE
                                       THEN MovementItem.Id
                                  ELSE 0
                             END AS MovementItemId_find

                           , COALESCE (MIFloat_MovementItemId.ValueData, 0) :: Integer AS MovementItemId_Partion

                      FROM MovementItem
                           LEFT JOIN _tmpScale_receipt ON _tmpScale_receipt.GoodsId_from = MovementItem.ObjectId

                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                       ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                       AND vbMovementDescId <> zc_Movement_ProductionSeparate() -- !!!���� ������ ������, �.�. � UNION �� ���!!!
                                                       AND vbMovementDescId <> zc_Movement_ProductionUnion() -- !!!���� ������ ������, �.�. � UNION �� ���!!!

                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                           LEFT JOIN MovementItemString AS MIString_KVK
                                                        ON MIString_KVK.MovementItemId = MovementItem.Id
                                                       AND MIString_KVK.DescId = zc_MIString_KVK()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalKVK
                                                            ON MILinkObject_PersonalKVK.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PersonalKVK.DescId         = zc_MILinkObject_PersonalKVK()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                            ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                                                           AND vbMovementDescId                <> zc_Movement_Inventory()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                            ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset.DescId         = zc_MILinkObject_Asset()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                            ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset_two.DescId         = zc_MILinkObject_Asset_two()
                           LEFT JOIN MovementItemFloat AS MIFloat_PartionCell
                                                       ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                               AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsReWork = TRUE -- !!!�����!!!
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                                AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsReWork = TRUE -- !!!�����!!!

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )

           -- ���������
           SELECT CASE WHEN vbMovementDescId = zc_Movement_Loss()
                                 -- <��������>
                            THEN lpInsertUpdate_MovementItem_Loss_scale
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPrice               := 0
                                                        , inCountForPrice       := 0
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Send()
                                 -- <�����������>
                            THEN lpInsertUpdate_MovementItem_Send_Value
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inCount               := tmp.CountPack
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inPartNumber          := tmp.PartNumber
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := tmp.AssetId
                                                        , inAssetId_two         := tmp.AssetId_two
                                                        , inUnitId              := NULL -- !!!�� ������, ����� �� �����������!!!
                                                        , inStorageId           := NULL
                                                        , inPartionModelId      := NULL
                                                        , inPartionGoodsId      := NULL
                                                        , inUserId              := vbUserId
                                                         )

                       WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbDocumentKindId = zc_Enum_DocumentKind_CuterWeight()
                                 -- <������ � ������������> - ����������� �/� ���� �������
                            THEN lpUpdate_MI_ProductionUnion_CuterWeight
                                                         (inId                  := tmp.MovementItemId_Partion
                                                        , inAmount              := tmp.Amount
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbDocumentKindId = zc_Enum_DocumentKind_RealWeight()
                                 -- <������ � ������������> - ����������� �/� ���� �����
                            THEN lpUpdate_MI_ProductionUnion_RealWeight
                                                         (inId                  := tmp.MovementItemId_Partion
                                                        , inAmount              := tmp.Amount
                                                        , inCount               := tmp.Count
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbDocumentKindId = zc_Enum_DocumentKind_RealDelicShp()
                                 -- <������ � ������������> - ����������� �/� ���� ����� �����������
                            THEN lpUpdate_MI_ProductionUnion_RealDelicShp
                                                         (inId                  := tmp.MovementItemId_Partion
                                                        , inAmount              := tmp.Amount
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbDocumentKindId = zc_Enum_DocumentKind_RealDelicMsg()
                                 -- <������ � ������������> - ����������� �/� ���� ����� ���
                            THEN lpUpdate_MI_ProductionUnion_RealDelicMsg
                                                         (inId                  := tmp.MovementItemId_Partion
                                                        , inAmount              := tmp.Amount
                                                        , inCount               := tmp.Count
                                                        , inUserId              := vbUserId
                                                         )

                       WHEN vbMovementDescId = zc_Movement_ProductionUnion()
                                 -- <������ � ������������>
                            THEN lpInsertUpdate_MI_ProductionUnion_Master
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inCount               := tmp.Count
                                                        , inCuterWeight         := 0
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inPartNumber          := NULL
                                                        , inModel               := NULL
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inGoodsKindId_Complete   := NULL
                                                        , inStorageId              := -- !!!����� �������� ������ !!!
                                                                                      CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()) THEN tmp.MovementItemId_Partion ELSE 0 END
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = FALSE
                                 -- <������ �� ������������ - Separate>
                            THEN lpInsertUpdate_MI_ProductionSeparate_Master
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inStorageLineId       := tmp.StorageLineId
                                                        , inAmount              := tmp.Amount
                                                        , inLiveWeight          := tmp.LiveWeight
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = TRUE
                                 -- <������ � ������������ - Separate>
                            THEN lpInsertUpdate_MI_ProductionSeparate_Child
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inParentId            := NULL
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inStorageLineId       := tmp.StorageLineId
                                                        , inAmount              := tmp.Amount
                                                        , inLiveWeight          := tmp.LiveWeight
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Inventory()
                                 -- <��������������>
                            THEN lpInsertUpdate_MovementItem_Inventory
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inPrice               := 0 -- !!!�� ������, ����� �� �����������!!!
                                                        , inSumm                := 0 -- !!!�� ������, ����� �� �����������!!!
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inCount               := tmp.Count
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inPartNumber          := NULL
                                                        , inPartionGoodsId      := NULL
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inGoodsKindCompleteId := NULL
                                                        , inAssetId             := CASE WHEN vbMovementDescId = zc_Movement_Inventory() AND vbUnitId = 8459 -- ����������� ��������
                                                                                        THEN -1 * tmp.PartionCellId
                                                                                        ELSE NULL
                                                                                   END
                                                        , inUnitId              := NULL
                                                        , inStorageId           := NULL
                                                        , inPartionModelId      := NULL
                                                        , inUserId              := -1 * vbUserId
                                                         )

                  END AS tmpId
          FROM (SELECT MAX (tmp.MovementItemId)      AS MovementItemId_find
                     , tmp.MovementItemId_Partion
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , tmp.StorageLineId
                     , tmp.AssetId
                     , tmp.AssetId_two
                     , tmp.PartionCellId
                     , tmp.PartionGoodsDate
                     , tmp.PartionGoods
                     , tmp.PartNumber
                     , SUM (tmp.Amount)       AS Amount
                     , SUM (tmp.Count)        AS Count
                     , SUM (tmp.CountPack)    AS CountPack
                     , SUM (tmp.HeadCount)    AS HeadCount
                     , SUM (tmp.LiveWeight)   AS LiveWeight
                FROM (-- �������� �����������
                      SELECT 0 AS MovementItemId
                           , tmpMI_ScaleCeh.GoodsId

                           , tmpMI_ScaleCeh.GoodsKindId

                           , tmpMI_ScaleCeh.StorageLineId

                           , tmpMI_ScaleCeh.AssetId
                           , tmpMI_ScaleCeh.AssetId_two

                           , tmpMI_ScaleCeh.PartionCellId

                           , tmpMI_ScaleCeh.PartNumber

                           , tmpMI_ScaleCeh.PartionGoodsDate

                           , tmpMI_ScaleCeh.PartionGoods

                           , tmpMI_ScaleCeh.Amount -- !!! ��� ������ ��� ����������� � �����������!!
                           , tmpMI_ScaleCeh.Count
                           , tmpMI_ScaleCeh.CountPack
                           , tmpMI_ScaleCeh.HeadCount
                           , tmpMI_ScaleCeh.LiveWeight

                           , tmpMI_ScaleCeh.Amount_mi
                           , tmpMI_ScaleCeh.myId

                           , tmpMI_ScaleCeh.MovementItemId_Partion

                      FROM tmpMI_ScaleCeh

                     UNION ALL
                      -- �������� ����������� - ����
                      SELECT 0 AS MovementItemId
                           , OL_Box_Goods.ChildObjectId AS GoodsId

                           , 0 AS GoodsKindId

                           , 0 AS StorageLineId

                           , 0 AS AssetId
                           , 0 AS AssetId_two

                           , 0 AS PartionCellId

                           , '' AS PartNumber

                           , zc_DateStart() :: TDateTime AS PartionGoodsDate

                           , '' AS PartionGoods

                           , SUM (MIF_CountTare.ValueData) AS Amount
                           , 0 AS Count
                           , 0 AS CountPack
                           , 0 AS HeadCount
                           , 0 AS LiveWeight

                           , SUM (MIF_CountTare.ValueData) AS Amount_mi
                           , 0 AS myId

                           , 0 AS MovementItemId_Partion

                      FROM tmpMI_ScaleCeh
                            INNER JOIN MovementItemFloat AS MIF_MovementItemId
                                                         ON MIF_MovementItemId.MovementItemId = tmpMI_ScaleCeh.MovementItemId_find
                                                        AND MIF_MovementItemId.DescId         = zc_MIFloat_MovementItemId()

                           INNER JOIN (SELECT zc_MIFloat_CountTare1() AS DescId_MIF, zc_MILinkObject_Box1() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare2() AS DescId_MIF, zc_MILinkObject_Box2() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare3() AS DescId_MIF, zc_MILinkObject_Box3() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare4() AS DescId_MIF, zc_MILinkObject_Box4() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare5() AS DescId_MIF, zc_MILinkObject_Box5() AS DescId_MILO
                                      ) AS tmpDesc ON tmpDesc.DescId_MIF > 0
                            INNER JOIN MovementItemFloat AS MIF_CountTare
                                                         ON MIF_CountTare.MovementItemId = MIF_MovementItemId.ValueData :: Integer
                                                        AND MIF_CountTare.DescId         = tmpDesc.DescId_MIF
                                                        AND MIF_CountTare.ValueData      > 0
                            INNER JOIN MovementItemLinkObject AS MILO_Box
                                                              ON MILO_Box.MovementItemId = MIF_MovementItemId.ValueData :: Integer
                                                             AND MILO_Box.DescId         = tmpDesc.DescId_MILO
                            INNER JOIN ObjectLink AS OL_Box_Goods
                                                  ON OL_Box_Goods.ObjectId = MILO_Box.ObjectId
                                                 AND OL_Box_Goods.DescId   = zc_ObjectLink_Box_Goods()

                      WHERE tmpMI_ScaleCeh.MovementItemId_find > 0
                      GROUP BY OL_Box_Goods.ChildObjectId

                     UNION ALL
                      -- �������� ��������� (���� ��������� ������)
                      SELECT tmpMI.MovementItemId
                           , tmpMI.GoodsId
                           , tmpMI.GoodsKindId
                           , tmpMI.StorageLineId
                           , tmpMI.AssetId
                           , tmpMI.AssetId_two
                           , tmpMI.PartionCellId
                           , tmpMI.PartNumber
                           , tmpMI.PartionGoodsDate
                           , tmpMI.PartionGoods


                           , tmpMI.Amount
                           , tmpMI.Count
                           , tmpMI.CountPack
                           , tmpMI.HeadCount
                           , tmpMI.LiveWeight

                           , tmpMI.Amount_mi
                           , tmpMI.myId

                           , tmpMI.MovementItemId_Partion
                      FROM tmpMI
                      WHERE tmpMI.Ord = 1
                     ) AS tmp
                GROUP BY tmp.MovementItemId_Partion
                       , tmp.GoodsId
                       , tmp.GoodsKindId
                       , tmp.StorageLineId
                       , tmp.AssetId
                       , tmp.AssetId_two
                       , tmp.PartionCellId
                       , tmp.PartionGoodsDate
                       , tmp.PartionGoods
                       , tmp.PartNumber
                       , tmp.myId -- ���� ��� ������������ - ������ ����������� � ��������� �������
                HAVING SUM (tmp.Amount_mi) <> 0
               ) AS tmp
          ) AS tmp;


     -- �������� ������ �� ������������
     IF vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
     THEN
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                  := tmp.MovementItemId
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inParentId            := COALESCE (MI_find.ParentId, tmpMI_master.MovementItemId)
                                                        , inPartionGoodsDate    := NULL
                                                        , inPartionGoods        := NULL
                                                        , inPartNumber          := NULL
                                                        , inModel               := NULL
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inGoodsKindCompleteId := NULL
                                                        , inStorageId           := NULL
                                                        , inCount_onCount       := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = tmp.MovementItemId AND DescId = zc_MIFloat_Count()), 0)
                                                        , inUserId              := vbUserId
                                                         )
          FROM (SELECT MAX (tmp.MovementItemId) AS MovementItemId
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , SUM (tmp.Amount) AS Amount
                FROM (-- �������� �����������
                      SELECT 0 AS MovementItemId
                           , MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount
                           , MovementItem.Amount AS Amount_mi
                      FROM MovementItem
                           -- ����� ������ ��� "�������� �������"
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                           AND vbDocumentKindId                      =  zc_Enum_DocumentKind_PackDiff()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     UNION ALL
                      -- �������� ��������� (���� ��������� ������)
                      SELECT MovementItem.Id AS MovementItemId
                           , MovementItem.ObjectId  AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount
                           , 0 AS Amount_mi
                      FROM MovementItem
                           -- ����� ������ ��� "�������� �������"
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                           AND vbDocumentKindId                      =  zc_Enum_DocumentKind_PackDiff()
                      WHERE MovementItem.MovementId = vbMovementId_find
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                        -- !!! �� ���������� � ���������� ������������
                        -- AND COALESCE (vbDocumentKindId, 0) <> zc_Enum_DocumentKind_PackDiff()
                     ) AS tmp
                GROUP BY tmp.GoodsId, tmp.GoodsKindId
                HAVING SUM (tmp.Amount_mi) <> 0
               ) AS tmp
               LEFT JOIN _tmpScale_receipt ON _tmpScale_receipt.GoodsId_from = tmp.GoodsId
               LEFT JOIN MovementItem AS MI_find ON MI_find.Id = tmp.MovementItemId
               LEFT JOIN (-- ����� ������
                          SELECT MAX (MovementItem.Id) AS MovementItemId
                               , MovementItem.ObjectId AS GoodsId
                          FROM MovementItem
                          WHERE MovementItem.MovementId = vbMovementId_begin --
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId
                         ) AS tmpMI_master ON tmpMI_master.GoodsId = _tmpScale_receipt.GoodsId_to
                                          AND MI_find.Id IS NULL
          ;
     END IF;
     -- �������� ������ �� �����������
     IF vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsReWork = TRUE
     THEN
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                  := 0
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inParentId            := vbId_tmp
                                                        , inPartionGoodsDate    := NULL
                                                        , inPartionGoods        := NULL
                                                        , inPartNumber          := NULL
                                                        , inModel               := NULL
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inGoodsKindCompleteId := NULL
                                                        , inStorageId           := NULL
                                                        , inCount_onCount       := 0
                                                        , inUserId              := vbUserId
                                                         )
          FROM (SELECT tmp.GoodsId
                     , tmp.GoodsKindId
                     , SUM (tmp.Amount) AS Amount
                FROM (SELECT MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     ) AS tmp
                GROUP BY tmp.GoodsId
                       , tmp.GoodsKindId
               ) AS tmp
          ;
     END IF;


     -- !!!!!!!!!!!!!!
     -- !!!��������!!!
     -- !!!!!!!!!!!!!!

     -- <��������>
     IF vbMovementDescId = zc_Movement_Loss()
     THEN
         -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <����������� �� ����>
         PERFORM lpComplete_Movement_Loss_CreateTemp();
         -- �������� ��������
         PERFORM lpComplete_Movement_Loss (inMovementId     := vbMovementId_begin
                                         , inUserId         := vbUserId);
     ELSE
          -- <�����������>
          IF vbMovementDescId = zc_Movement_Send() AND vbIsUpak_UnComplete = FALSE
          THEN
              -- �������� ��������
              PERFORM gpComplete_Movement_Send (inMovementId     := vbMovementId_begin
                                              , inIsLastComplete := NULL
                                              , inSession        := inSession);
          ELSE
               -- <������ � ������������>
               IF vbMovementDescId = zc_Movement_ProductionUnion() AND vbDocumentKindId NOT IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg())
               THEN
                   -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <����������� �� ����>
                   PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
                   -- �������� ��������
                   PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := vbMovementId_begin
                                                              , inIsHistoryCost  := FALSE
                                                              , inUserId         := vbUserId);
               ELSE
               -- <��������������>
               IF vbMovementDescId = zc_Movement_Inventory() AND COALESCE (vbIsCloseInventory, TRUE) = TRUE

                THEN
                   -- �������� ��������
                   PERFORM gpComplete_Movement_Inventory (inMovementId     := vbMovementId_begin
                                                        , inIsLastComplete := NULL
                                                        , inSession        := inSession);
               END IF;
               END IF;
               END IF;
     END IF;


     -- ����� - ��������� <��������> - <����������� (������������)> - ������ ���� + ParentId + AccessKeyId
     PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, inOperDate, COALESCE (Movement_begin.Id, Movement.ParentId), COALESCE (Movement_begin.AccessKeyId, Movement.AccessKeyId))
     FROM Movement
          LEFT JOIN Movement AS Movement_begin ON Movement_begin.Id = vbMovementId_begin
     WHERE Movement.Id = inMovementId;

     -- ��������� �������� <�������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inMovementId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), inMovementId, vbPartionGoods);
     --
     IF vbMovementDescId = zc_Movement_ProductionSeparate()
        -- !!!����� �.�. ������ ��� �������� ���� �����-�� ������ ����� ....!!!
        -- OR (vbMovementDescId = zc_Movement_ProductionUnion() AND inBranchCode BETWEEN 201 AND 210) -- ���� �������
     THEN
          -- ��������� �������� <����� �����������>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inMovementId, vbWeighingNumber);
     END IF;


     -- �������� ��-�� - vbIsRePack
     IF vbIsRePack = TRUE
     THEN
          -- ���������
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isRePack(), vbMovementId_begin, TRUE);
          --
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), MovementItem.Id, zc_PartionCell_RK())
                , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), MovementItem.Id, TRUE)
             --, lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), MovementItem.Id, 0)
          FROM MovementItem
          WHERE MovementItem.MovementId = vbMovementId_begin
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE
           ;

     END IF;


     -- ����� - ����������� ������ ������ ��������� + ��������� �������� - <����������� (������������)>
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingProduction()
                                , inUserId     := vbUserId
                                 );


     -- !!!��������!!!
     IF vbMovementDescId = zc_Movement_Inventory()
     THEN -- !!!�������� ��� �������� ����!!!
          IF EXISTS (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                        ON MovementLinkObject_From_find.MovementId = inMovementId
                                                       AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                       AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                      WHERE Movement.Id <> vbMovementId_begin
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.OperDate = vbOperDate_invent
                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                    )
          THEN
              RAISE EXCEPTION '������ <%>.�������� <��������������> �� <%> ��� ����������.��������� �������� ����� 15 ���.'
                  , (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                        ON MovementLinkObject_From_find.MovementId = inMovementId
                                                       AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                       AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                      WHERE Movement.Id <> vbMovementId_begin
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.OperDate = vbOperDate_invent
                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                    )
                  , zfConvert_DateToString (vbOperDate_invent);
          END IF;

          -- !!!�������� ��� ������� ����!!!
          IF 1=0
         AND EXISTS (SELECT 1
                     FROM MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                     ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                          LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                       ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                      WHERE MovementItem.MovementId = vbMovementId_begin
                        AND MovementItem.isErased = FALSE
                        AND MovementItem.Amount <> 0
                      GROUP BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId, COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()), COALESCE (MIString_PartionGoods.ValueData, '')
                      HAVING COUNT (*) > 1
                    )
          THEN
              RAISE EXCEPTION '������.�������� <��������������> �� <%> ������������ ������ �������������.��������� �������� ����� 25 ���. <%> <%>', DATE (inOperDate - INTERVAL '1 DAY')
                  , lfGet_Object_ValueData (
                    (SELECT MovementItem.ObjectId
                     FROM MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                     ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                          LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                       ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                      WHERE MovementItem.MovementId = vbMovementId_begin
                        AND MovementItem.isErased = FALSE
                        AND MovementItem.Amount <> 0
                      GROUP BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId, COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()), COALESCE (MIString_PartionGoods.ValueData, '')
                      HAVING COUNT (*) > 1
                      ORDER BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId
                      LIMIT 1
                     ))
                  , lfGet_Object_ValueData (
                    (SELECT MILinkObject_GoodsKind.ObjectId
                     FROM MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                     ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                          LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                       ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                      WHERE MovementItem.MovementId = vbMovementId_begin
                        AND MovementItem.isErased = FALSE
                        AND MovementItem.Amount <> 0
                      GROUP BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId, COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()), COALESCE (MIString_PartionGoods.ValueData, '')
                      HAVING COUNT (*) > 1
                      ORDER BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId
                      LIMIT 1
                     ))
                ;
          END IF;

     END IF;

     -- !!!����� �.�. ������ ��� �������� ���� �����-�� ������ ����� ....!!!
     /*-- !!!��������!!!
     IF vbMovementDescId = zc_Movement_ProductionUnion() AND inBranchCode BETWEEN 201 AND 210 -- ���� �������
     THEN -- !!!�������� ��� �������� ����!!!
          IF EXISTS (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                        ON MovementLinkObject_From_find.MovementId = inMovementId
                                                       AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                       AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                          INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                        ON MovementLinkObject_To_find.MovementId = inMovementId
                                                       AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                      WHERE Movement.Id <> vbMovementId_begin
                        AND Movement.DescId = zc_Movement_ProductionUnion()
                        AND Movement.OperDate = inOperDate
                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                    )
          THEN
              RAISE EXCEPTION '������ <%>.�������� <��������> �� <%> ��� ����������.��������� �������� ����� 15 ���.'
                  , (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                        ON MovementLinkObject_From_find.MovementId = inMovementId
                                                       AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                       AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                          INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                        ON MovementLinkObject_To_find.MovementId = inMovementId
                                                       AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                      WHERE Movement.Id <> vbMovementId_begin
                        AND Movement.DescId = zc_Movement_ProductionUnion()
                        AND Movement.OperDate = inOperDate
                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                    )
                  , DATE (inOperDate);
          END IF;

          -- !!!�������� ��� ������� ����!!!
          IF EXISTS (SELECT 1
                     FROM MovementItem
                     WHERE MovementItem.MovementId = vbMovementId_begin
                       AND MovementItem.isErased = FALSE
                     GROUP BY MovementItem.ObjectId, MovementItem.DescId
                     HAVING COUNT (*) > 1
                    )
          THEN
              RAISE EXCEPTION '������.�������� <��������> �� <%> ������������ ������ �������������.��������� �������� ����� 25 ���.', DATE (inOperDate);
          END IF;

     END IF;*/


     -- !!!�� ������� ��������!!!
     IF vbMovementDescId = zc_Movement_Send()
        AND EXISTS (SELECT 1
                    FROM MovementLinkObject AS MLO_From
                         INNER JOIN MovementLinkObject AS MLO_To
                                                       ON MLO_To.MovementId = inMovementId
                                                      AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                      -- !!!������ �� ��!!!
                                                      AND MLO_To.ObjectId   = zc_Unit_RK()
                    WHERE MLO_From.MovementId = inMovementId
                      AND MLO_From.DescId     = zc_MovementLinkObject_From()
                      -- !!!������ � ��������!!!
                      AND MLO_From.ObjectId   IN (zc_Unit_Pack(), zc_Unit_RK_Label())
                   )
        -- AND vbUserId = 5
     THEN
         PERFORM lpUpdate_MI_Send_byWeighingProduction_all (inOperDate       := inOperDate
                                                          , inMovementId_from:= inMovementId
                                                          , inMovementId_To  := vbMovementId_begin
                                                          , inUserId         := vbUserId
                                                           );
         -- RAISE EXCEPTION 'Admin - ok';
     END IF;


     -- ������ ��� zc_Movement_ProductionSeparate - ��������� ��������� �������
     IF vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = TRUE AND vbUserId = 5
     THEN
         -- ��� ������ ������� - ����� ��������� 1)zc_Movement_WeighingProduction + 2)zc_Movement_ProductionSeparate
         PERFORM gpInsert_ScaleCeh_GoodsSeparate (inMovementId          := inMovementId
                                                , inOperDate            := tmp.OperDate
                                                , inMovementDescId      := tmp.MovementDescId     :: Integer
                                                , inMovementDescNumber  := tmp.MovementDescNumber :: Integer
                                                , inFromId              := tmp.FromId
                                                , inToId                := tmp.ToId
                                                , inIsProductionIn      := FALSE        -- ������ ������
                                                , inBranchCode          := inBranchCode --
                                                , inGoodsId             := tmp.GoodsId
                                                , inPartionGoods        := (COALESCE (GoodsCode, 0) :: TVarChar
                                                                           || '-' || TO_CHAR (inOperDate, 'DD.MM.YYYY')) :: TVarChar
                                                , inAmount              := tmp.Amount
                                                , inHeadCount           := 0 :: TFloat
                                                , inIsClose             := FALSE
                                                , inSession             := inSession
                                                 )
         FROM (WITH tmpMovement AS (SELECT Movement.OperDate                          AS OperDate
                                         , MovementLinkObject_From.ObjectId           AS FromId
                                         , MovementLinkObject_To.ObjectId             AS ToId
                                         , MovementFloat_MovementDesc.ValueData       AS MovementDescId
                                         , MovementFloat_MovementDescNumber.ValueData AS MovementDescNumber
                                    FROM Movement
                                         LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                                                 ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                                                AND MovementFloat_MovementDescNumber.DescId     = zc_MovementFloat_MovementDescNumber()
                                         LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                                                 ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                                                AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                    WHERE Movement.Id = inMovementId
                                   )
                  , tmpGoodsScaleCeh AS (SELECT tmpMovement.OperDate
                                              , tmpMovement.FromId
                                              , tmpMovement.ToId
                                              , tmpMovement.MovementDescId
                                              , tmpMovement.MovementDescNumber
                                              , Object_Goods.Id         AS GoodsId
                                              , Object_Goods.ObjectCode AS GoodsCode
                                         FROM Object AS Object_GoodsScaleCeh
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_Goods
                                                                   ON ObjectLink_GoodsScaleCeh_Goods.ObjectId = Object_GoodsScaleCeh.Id
                                                                  AND ObjectLink_GoodsScaleCeh_Goods.DescId = zc_ObjectLink_GoodsScaleCeh_Goods()
                                              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsScaleCeh_Goods.ChildObjectId

                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_From
                                                                   ON ObjectLink_GoodsScaleCeh_From.ObjectId = Object_GoodsScaleCeh.Id
                                                                  AND ObjectLink_GoodsScaleCeh_From.DescId   = zc_ObjectLink_GoodsScaleCeh_From()
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_To
                                                                   ON ObjectLink_GoodsScaleCeh_To.ObjectId = Object_GoodsScaleCeh.Id
                                                                  AND ObjectLink_GoodsScaleCeh_To.DescId   = zc_ObjectLink_GoodsScaleCeh_To()

                                              INNER JOIN tmpMovement ON tmpMovement.FromId = ObjectLink_GoodsScaleCeh_From.ChildObjectId
                                                                    AND tmpMovement.ToId   = ObjectLink_GoodsScaleCeh_To.ChildObjectId
                                         WHERE Object_GoodsScaleCeh.DescId   = zc_Object_GoodsScaleCeh()
                                           AND Object_GoodsScaleCeh.isErased = FALSE
                                        )
               -- ���������
               SELECT tmpGoodsScaleCeh.OperDate
                    , tmpGoodsScaleCeh.FromId
                    , tmpGoodsScaleCeh.ToId
                    , tmpGoodsScaleCeh.MovementDescId
                    , tmpGoodsScaleCeh.MovementDescNumber
                    , tmpGoodsScaleCeh.GoodsId
                    , tmpGoodsScaleCeh.GoodsCode
                    , SUM (MovementItem.Amount) AS Amount
               FROM MovementItem
                    INNER JOIN tmpGoodsScaleCeh ON tmpGoodsScaleCeh.GoodsId = MovementItem.ObjectId
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
               GROUP BY tmpGoodsScaleCeh.OperDate
                      , tmpGoodsScaleCeh.FromId
                      , tmpGoodsScaleCeh.ToId
                      , tmpGoodsScaleCeh.MovementDescId
                      , tmpGoodsScaleCeh.MovementDescNumber
                      , tmpGoodsScaleCeh.GoodsId
                      , tmpGoodsScaleCeh.GoodsCode
              ) AS tmp;

     END IF;


if (vbUserId = 5 AND 1=1)
then
    RAISE EXCEPTION 'Admin - Errr _end <%>  <%>', (select Movement.InvNumber from Movement where Movement.Id = vbMovementId_begin), vbMovementId_begin;
    -- '��������� �������� ����� 3 ���.'
end if;

     -- ���������
     RETURN QUERY
       SELECT vbMovementId_begin AS MovementId_begin;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.07.15                                        * !!!�������� ��� �������� ����!!!
 11.06.15                                        *
*/

-- ����
-- SELECT * FROM gpInsert_ScaleCeh_Movement_all (inBranchCode:= 0, inMovementId:= 10, inOperDate:= '01.01.2015', inSession:= zfCalc_UserAdmin())
