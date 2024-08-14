 -- Function: gpUpdate_MI_ProductionUnion_AmountNext_out()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_AmountNext_out (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_AmountNext_out(
    IN inMovementId       Integer   , -- ���� ������� <>
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbFromId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_AmountNext_out());
   
   -- ��������
   IF COALESCE (inMovementId, 0) = 0 
   THEN
       RAISE EXCEPTION '������.�������� �� ��������.';
   END IF;

   vbFromId := (SELECT MLO_From.ObjectId
                FROM MovementLinkObject AS MLO_From
                WHERE MLO_From.MovementId = inMovementId
                  AND MLO_From.DescId = zc_MovementLinkObject_From()
                );
   
   -- ��������� �������� <����������� �/� (������), ��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNext_out(), tmp.Id, COALESCE (tmp.AmountNext_out,0)::TFloat)
   FROM (WITH -- ������� �/� ��
         tmpMI_WorkProgress_in AS
                     (SELECT MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ContainerId                 AS ContainerId
                      FROM MovementItemContainer AS MIContainer
                          LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                    ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                   AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                                   AND MovementBoolean_Peresort.ValueData = TRUE

                      WHERE MIContainer.MovementId = inMovementId
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        AND MIContainer.IsActive = TRUE
                        AND MovementBoolean_Peresort.MovementId IS NULL    -- !!!������ �����������!!!
                        AND MIContainer.Amount <> 0
                        AND (MIContainer.ObjectIntId_Analyzer IN (zc_GoodsKind_WorkProgress(), zc_GoodsKind_Basis()) -- ����������� ��� ��� �/� ��
                             )
                      )
         -- ������� �/� �� � ������� ParentId
       , tmpMI_WorkProgress_out AS
                     (SELECT MIContainer.ParentId
                           , tmpMI_WorkProgress_in.ContainerId
                           , SUM (MIContainer.Amount) AS Amount
                      FROM tmpMI_WorkProgress_in
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpMI_WorkProgress_in.ContainerId
                                                           AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                           AND MIContainer.IsActive = FALSE
                           INNER JOIN MovementBoolean AS MovementBoolean_Peresort
                                                      ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                     AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                                     AND MovementBoolean_Peresort.ValueData = TRUE
                     GROUP BY MIContainer.ParentId
                            , tmpMI_WorkProgress_in.ContainerId
                     )

         -- ������������� �� ������ 
       , tmpUnit_oth AS (-- "������� ������� �����", �� ���������� - !!!�����������!!!
                         SELECT tmpSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8439) AS tmpSelect
                         WHERE vbFromId NOT IN (951601, 981821) -- ��� �������� ���� + ��� �����. ����
                           AND tmpSelect.UnitId NOT IN (133049)-- "����� ���������� ����"
                        UNION
                         -- "��� �������+���-��"
                         SELECT tmpSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmpSelect
                        UNION
                         -- "��� ������� + ���������� (����)"
                         SELECT 8020711 AS UnitId
                        )
       
         -- ������� �/� �� � ������� ParentId - ���� ��� ���� �� "�����������"
       , tmpMI_WorkProgress_oth AS   ----����������� �/� (������), ��
                                  (SELECT tmpMI_WorkProgress_out.ContainerId
                                        , -1 * SUM (tmpMI_WorkProgress_out.Amount) AS Amount
                                   FROM tmpMI_WorkProgress_out
                                        INNER JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.Id = tmpMI_WorkProgress_out.ParentId
                                        INNER JOIN tmpUnit_oth ON tmpUnit_oth.UnitId = MIContainer.WhereObjectId_Analyzer
                                  GROUP BY tmpMI_WorkProgress_out.ContainerId
                                  )
                     
       SELECT tmpMI_WorkProgress_in.MovementItemId AS Id
            , tmpMI_WorkProgress_oth.Amount        AS AmountNext_out
       FROM tmpMI_WorkProgress_in
            LEFT JOIN tmpMI_WorkProgress_oth ON tmpMI_WorkProgress_oth.ContainerId = tmpMI_WorkProgress_in.ContainerId
       ) AS tmp
       ;

     IF vbUserId = 9457
     THEN
         RAISE EXCEPTION 'Test. Ok!';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.08.24         * 
*/

-- ����             28608090 
--  select * from gpUpdate_MI_ProductionUnion_AmountNext_out(inMovementId := 28608090  ,  inSession := '9457');