-- Function: gpGet_ScaleCeh_Movement_checkPartion()

DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement_checkPartion (Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement_checkPartion (Integer, Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement_checkPartion (Integer, Integer, TVarChar, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleCeh_Movement_checkPartion(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- 
    IN inPartionGoods        TVarChar  , -- <������ ������> - ��� �������
    IN inOperCount           TFloat    , --
    IN inValueStep           Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Code       Integer
             , MessageStr TVarChar
             , ValueStep  Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementDescId Integer;
   DECLARE vbMovementId_find1 Integer;
   DECLARE vbMovementId_find2 Integer;
   DECLARE vbMovementId_find3 Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbMovementItemId_err Integer;
   DECLARE vbPartionGoods TVarChar;
   DECLARE vbPartionGoods_partner TVarChar;
   DECLARE vbIsProductionIn Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������ ����, ������ �����������
     vbOperDate:= gpGet_Scale_OperDate (inIsCeh:= TRUE, inBranchCode:= 201, inSession:= inSession);
     -- ���������� <MovementDescId>
     vbMovementDescId:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_MovementDesc()) :: Integer;
     -- ���������� <FromId>
     vbFromId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From());
     -- ���������� <ToId>
     vbToId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To());
     -- ���������� <������ ������> - ��� ��������
     vbPartionGoods:= (SELECT MAX (MIString_PartionGoods.ValueData)
                       FROM MovementItem
                            INNER JOIN MovementItemString AS MIString_PartionGoods
                                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                         AND MIString_PartionGoods.ValueData <> ''
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.isErased = FALSE
                      );
     -- ���������� <������ ������> - ��� ����������
     vbPartionGoods_partner:= zfFormat_PartionGoods (vbPartionGoods);

     -- ���������� <������ ��� ������>
     IF vbMovementDescId = zc_Movement_ProductionSeparate()
     THEN
          vbIsProductionIn:= (SELECT ValueData FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_isIncome());
          IF vbIsProductionIn IS NULL
          THEN 
              RAISE EXCEPTION '������.vbIsProductionIn-???   <%>   <%> ', inMovementId, zc_MovementBoolean_isIncome();
          END IF;
     END IF;

     -- 1. ������ ��� zc_Movement_ProductionSeparate + !!!�� ������, �.�. inGoodsId = 0!!!
     IF vbMovementDescId = zc_Movement_ProductionSeparate() AND COALESCE (inGoodsId, 0) = 0
     THEN
          -- �����1 ������������� ��������� <������������> �� ���� ���������� + ������ + �� vbOperDate
          vbMovementId_find1:= (SELECT Movement.Id
                                FROM (SELECT vbOperDate AS OperDate) AS tmp
                                     INNER JOIN Movement ON Movement.DescId = zc_Movement_ProductionSeparate()
                                                        AND Movement.OperDate = tmp.OperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = vbFromId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = vbToId
                                     INNER JOIN MovementString AS MovementString_PartionGoods
                                                               ON MovementString_PartionGoods.MovementId = Movement.Id
                                                              AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                              AND MovementString_PartionGoods.ValueData = vbPartionGoods
                                LIMIT 1
                               );
          -- �����2 ������������� ��������� <������������> �� ���� ���������� + ������ + �� vbOperDate - 1
          vbMovementId_find2:= (SELECT Movement.Id
                                FROM (SELECT vbOperDate - INTERVAL '1 DAY' AS OperDate) AS tmp
                                     INNER JOIN Movement ON Movement.DescId = zc_Movement_ProductionSeparate()
                                                        AND Movement.OperDate = tmp.OperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                     INNER JOIN MovementString AS MovementString_PartionGoods
                                                               ON MovementString_PartionGoods.MovementId = Movement.Id
                                                              AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                              AND MovementString_PartionGoods.ValueData = vbPartionGoods
                                LIMIT 1
                               );
          -- ������ ��� ������� �����
          IF vbFromId = 8442 AND vbToId = 8442 AND 1=0
          THEN
              -- �����3 ������������� ��������� <������ �� ����������> �� ���� ���������� + ������ + �� vbOperDate    -- �� 2 ���
              vbMovementId_find3:=
                               (SELECT Movement.Id
                                FROM (SELECT vbOperDate AS OperDate) AS tmp
                                     INNER JOIN Movement ON Movement.DescId = zc_Movement_Income()
                                                        AND Movement.OperDate = tmp.OperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = vbFromId -- !!!�� ������!!!
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId = zc_MI_Master()
                                                            AND MovementItem.isErased = FALSE
                                     INNER JOIN MovementItemString AS MIString_PartionGoodsCalc
                                                                   ON MIString_PartionGoodsCalc.MovementItemId =  MovementItem.Id
                                                                  AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()
                                                                  AND MIString_PartionGoodsCalc.ValueData = vbPartionGoods_partner
                                LIMIT 1
                               );
         ELSE
             -- ������ ������ ����������� �� �����
             vbMovementId_find3:= -1;
         END IF;

         -- 1.1. check PartionStr is null
         vbMovementItemId_err:= (SELECT MovementItem.Id
                                 FROM MovementItem
                                      LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                                   ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                                  AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.isErased = FALSE
                                   AND COALESCE (MIString_PartionGoods.ValueData, '') = ''
                                 LIMIT 1
                                );
         IF vbMovementItemId_err > 0
         THEN
              -- ��������� - err 1
              RETURN QUERY
                SELECT 1 AS Code
                     , ('������.' || CHR(10) || CHR(13) || '��� ������ <' || Object.ValueData || '> ��� = <' || MovementItem.Amount :: TVarChar || '>' || CHR(10) || CHR(13) || '�� ���������� <����� �����>.') :: TVarChar AS MessageStr
                     , 0 :: Integer AS ValueStep
                FROM MovementItem
                     LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                WHERE MovementItem.Id = vbMovementItemId_err;
              -- �����
              RETURN;
         END IF;

         -- 1.2. check one PartionStr
         IF EXISTS (SELECT 1
                    FROM (SELECT DISTINCT MIString_PartionGoods.ValueData AS PartionGoods
                          FROM MovementItem
                               LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                            ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                           AND MIString_PartionGoods.DescId         = zc_MIString_PartionGoods()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.isErased   = FALSE
                         ) AS tmp
                    HAVING Count(*) > 1)
         THEN
              -- ��������� - err 1
              RETURN QUERY
                SELECT 1 AS Code
                     , ('������.' || CHR(10) || CHR(13) || '��� ����������� ������ ���� � ���������� ������� ������ <' || vbPartionGoods || '>.') :: TVarChar AS MessageStr
                     , 0 :: Integer AS ValueStep
               ;
              -- �����
              RETURN;
         END IF;

         -- check ��� �������
         IF vbIsProductionIn = FALSE
         THEN
             -- 1.3. check one Goods ��� �������
             vbMovementItemId_err:= (SELECT MAX (tmp.GoodsId)
                                     FROM (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                                           FROM MovementItem
                                           WHERE MovementItem.MovementId = inMovementId
                                             AND MovementItem.isErased   = FALSE
                                          ) AS tmp
                                     HAVING Count(*) > 1
                                    );
             IF vbMovementItemId_err <> 0
             THEN
                  -- ��������� - err 1
                  RETURN QUERY
                    SELECT 1 AS Code
                         , ('������.' || CHR(10) || CHR(13) || '��� ����������� ������ ���� ��� ������ ������  <' || Object.ValueData || '>.') :: TVarChar AS MessageStr
                         , 0 :: Integer AS ValueStep
                    FROM Object
                    WHERE Object.Id = vbMovementItemId_err
                   ;
                  -- �����
                  RETURN;
             END IF;

             -- 1.4. check Goods by vbMovementId_find1 ��� �������
             vbMovementItemId_err:= (SELECT MovementItem.ObjectId
                                     FROM MovementItem
                                          INNER JOIN MovementItem AS MovementItem_find
                                                                  ON MovementItem_find.MovementId = inMovementId
                                                                 AND MovementItem_find.isErased   = FALSE
                                                                 AND MovementItem_find.ObjectId   <> MovementItem.ObjectId
                                     WHERE MovementItem.MovementId = vbMovementId_find1
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = FALSE
                                     LIMIT 1
                                    );
             IF vbMovementItemId_err <> 0
             THEN
                  -- ��������� - err 1
                  RETURN QUERY
                    SELECT 1 AS Code
                         , ('������.' || CHR(10) || CHR(13) || '� ������� ����������� ��� ������ <' || vbPartionGoods || '> ������ ���� ������ �����  <' || Object.ValueData || '>.') :: TVarChar AS MessageStr
                         , 0 :: Integer AS ValueStep
                    FROM Object
                    WHERE Object.Id = vbMovementItemId_err
                   ;
                  -- �����
                  RETURN;
             END IF;
         END IF;


         -- check ��� �������
         IF vbIsProductionIn = TRUE
         THEN
             -- 1.5. check need exists vbMovementId_find1 or vbMovementId_find2 ��� ������� + �� ����� (�.�. ����� vbMovementId_find3 = -1)
             vbMovementItemId_err:= (SELECT 1 WHERE COALESCE (vbMovementId_find1, 0) = 0 AND COALESCE (vbMovementId_find2, 0) = 0 AND vbMovementId_find3 = -1);
             IF vbMovementItemId_err <> 0
             THEN
                  -- ��������� - err 1
                  RETURN QUERY
                    SELECT 1 AS Code
                         , ('������.' || CHR(10) || CHR(13) || '������������ ������ ������ <' || vbPartionGoods || '> �������� ������ ����� ��������������� �������.') :: TVarChar AS MessageStr
                         , (inValueStep + 1) :: Integer AS ValueStep
                   ;
                  -- �����
                  RETURN;
             END IF;
         END IF;

         -- check ��� �����
         IF COALESCE (vbMovementId_find3, 0) <> -1
         THEN
             -- 1.6. check need exists vbMovementId_find3 ��� �����
             vbMovementItemId_err:= (SELECT 1 WHERE COALESCE (vbMovementId_find3, 0) = 0);
             IF vbMovementItemId_err <> 0
             THEN
                  -- ��������� - err 1
                  RETURN QUERY
                    SELECT 1 AS Code
                         , ('������.' || CHR(10) || CHR(13) || CASE WHEN vbIsProductionIn = TRUE THEN '������' ELSE '������' END || ' � ����� ������������ ������.'
                                      || CHR(10) || CHR(13) || '�� ������ ������ �� ���������� ��� ������ <' || vbPartionGoods_partner || '>.���� ������� = <' || zfConvert_DateToString (vbOperDate) || '>'
                           ) :: TVarChar AS MessageStr
                         , 0 :: Integer AS ValueStep
                   ;
                  -- �����
                  RETURN;
             END IF;
         END IF;

     END IF;



     -- 2. ������ ��� Deftroster
     IF vbFromId = 8440 -- ���������
       AND ((vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = FALSE)
         OR (vbMovementDescId = zc_Movement_Send())
           )
     THEN
          -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
          CREATE TEMP TABLE _tmpPartionGoods_check (GoodsId Integer, PartionGoods TVarChar, OperCount_in TFloat, OperCount_out TFloat, OperCount_scale TFloat, OperCount TFloat) ON COMMIT DROP;
          WITH tmpMI AS (SELECT MovementItem.ObjectId           AS GoodsId
                              , COALESCE (zfFormat_PartionGoods (MIString_PartionGoods.ValueData), '') AS PartionGoods -- !!!����������� ��������������� ������!!!
                              , MovementItem.Amount             AS OperCount_scale
                              , 0                               AS OperCount
                         FROM MovementItem
                              LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                           ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                          AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.isErased = FALSE
                           AND (MovementItem.ObjectId = inGoodsId OR COALESCE (inGoodsId, 0) = 0)
                           AND (MIString_PartionGoods.ValueData = inPartionGoods OR COALESCE (inPartionGoods, '') = '')
                        UNION ALL
                         SELECT inGoodsId      AS GoodsId
                              , inPartionGoods AS PartionGoods
                              , 0              AS OperCount_scale
                              , inOperCount    AS OperCount
                         WHERE inGoodsId <> 0
                        )
         , tmpPartionGoods AS (SELECT tmpMI.GoodsId, tmpMI.PartionGoods FROM tmpMI GROUP BY tmpMI.GoodsId, tmpMI.PartionGoods)
         , tmpGoods AS (SELECT tmpMI.GoodsId FROM tmpMI GROUP BY tmpMI.GoodsId)
         , tmpMovementDesc AS (SELECT zc_Movement_Send() AS DescId UNION SELECT zc_Movement_ProductionSeparate() AS DescId)
         , tmpMovement  AS (SELECT tmpGoods.GoodsId
                                 , COALESCE (zfFormat_PartionGoods (COALESCE (MovementString_PartionGoods.ValueData, MIString_PartionGoods.ValueData)), '') AS PartionGoods -- !!!����������� ��������������� ������!!!
                                 , SUM (CASE WHEN MovementLinkObject.DescId = zc_MovementLinkObject_To()   THEN MovementItem.Amount ELSE 0 END) AS OperCount_in
                                 , SUM (CASE WHEN MovementLinkObject.DescId = zc_MovementLinkObject_From() THEN MovementItem.Amount ELSE 0 END) AS OperCount_out
                            FROM tmpMovementDesc
                                 INNER JOIN Movement ON Movement.DescId = tmpMovementDesc.DescId
                                                    AND Movement.OperDate BETWEEN (vbOperDate - INTERVAL '1 DAY') AND vbOperDate
                                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 INNER JOIN MovementLinkObject ON MovementLinkObject.ObjectId = vbFromId
                                                              AND MovementLinkObject.MovementId = Movement.Id
                                                              -- AND MovementLinkObject.DescId = ...
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.isErased = FALSE
                                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                 LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                              ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                             AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                             AND tmpMovementDesc.DescId = zc_Movement_Send()
                                 LEFT JOIN MovementString AS MovementString_PartionGoods
                                                          ON MovementString_PartionGoods.MovementId = Movement.Id
                                                         AND MovementString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                         AND tmpMovementDesc.DescId = zc_Movement_ProductionSeparate()
                            GROUP BY tmpGoods.GoodsId
                                   , MIString_PartionGoods.ValueData
                                   , MovementString_PartionGoods.ValueData
                           )
         , tmpResult AS (SELECT tmpMI.GoodsId
                              , tmpMI.PartionGoods
                              , 0 AS OperCount_in
                              , 0 AS OperCount_out
                              , tmpMI.OperCount_scale
                              , tmpMI.OperCount
                         FROM tmpMI
                        UNION ALL
                         SELECT tmpMovement.GoodsId
                              , tmpMovement.PartionGoods
                              , tmpMovement.OperCount_in
                              , tmpMovement.OperCount_out
                              , 0 AS OperCount_scale
                              , 0 AS OperCount
                         FROM tmpPartionGoods
                              INNER JOIN tmpMovement ON tmpMovement.GoodsId = tmpPartionGoods.GoodsId
                                                    AND tmpMovement.PartionGoods = tmpPartionGoods.PartionGoods
                        )
          -- ��������
          INSERT INTO _tmpPartionGoods_check (GoodsId, PartionGoods, OperCount_in, OperCount_out, OperCount_scale, OperCount)
             SELECT GoodsId, PartionGoods, SUM (OperCount_in), SUM (OperCount_out), SUM (OperCount_scale), SUM (OperCount)
             FROM tmpResult
             GROUP BY GoodsId, PartionGoods
             HAVING SUM (OperCount_in) < SUM (OperCount_out) + SUM (OperCount_scale) + SUM (OperCount);
          --
          IF EXISTS (SELECT * FROM _tmpPartionGoods_check)
          THEN
                -- ��������� - err 1
                RETURN QUERY
                  SELECT 2 AS Code
                       , ('������.' || CHR(10) || CHR(13)
                       || '�������� ���-�� ��� <' || Object.ValueData || '>.' || CHR(10) || CHR(13)
                       || '������ ������ <' || _tmpPartionGoods_check.PartionGoods :: TVarChar || '> �� ����� ���� ������ �������.' || CHR(10) || CHR(13)
                       || '������ ������ ����� : <' || _tmpPartionGoods_check.OperCount_in :: TVarChar || '>' || CHR(10) || CHR(13)
                       || '������ ������ ����� : <' || (_tmpPartionGoods_check.OperCount_out + _tmpPartionGoods_check.OperCount_scale + _tmpPartionGoods_check.OperCount) :: TVarChar || '>'
                       || ' = <' || CASE WHEN _tmpPartionGoods_check.OperCount <> 0 THEN _tmpPartionGoods_check.OperCount :: TVarChar ELSE '' END :: TVarChar
                       ||           CASE WHEN _tmpPartionGoods_check.OperCount <> 0  AND _tmpPartionGoods_check.OperCount_scale <> 0 THEN ' + ' ELSE '' END :: TVarChar
                       ||           CASE WHEN _tmpPartionGoods_check.OperCount_scale <> 0 THEN _tmpPartionGoods_check.OperCount_scale :: TVarChar ELSE '' END :: TVarChar
                       || '> (������)'
                       || CASE WHEN _tmpPartionGoods_check.OperCount_out <> 0 THEN ' + <' || _tmpPartionGoods_check.OperCount_out :: TVarChar || '> (������)' ELSE '' END
                       || CHR(10) || CHR(13)
                       || '����������?'
                         ) :: TVarChar AS MessageStr
                       , 0 :: Integer AS ValueStep
                  FROM _tmpPartionGoods_check
                       LEFT JOIN Object ON Object.Id = _tmpPartionGoods_check.GoodsId
                  LIMIT 1
                 ;
           ELSE
               -- ��������� - ��� ��
               RETURN QUERY
                 SELECT 0 AS Code, '' :: TVarChar AS MessageStr, 0 :: Integer AS ValueStep;
           END IF;

     ELSE
         -- ��������� - ��� ��
         RETURN QUERY
           SELECT 0 AS Code, '' :: TVarChar AS MessageStr, 0 :: Integer AS ValueStep;
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.06.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_ScaleCeh_Movement_checkPartion (inMovementId:= 1, inGoodsId:= 1, inPartionGoods:= '1', inOperCount:= 1, inValueStep:= 1, inSession:= '5')
