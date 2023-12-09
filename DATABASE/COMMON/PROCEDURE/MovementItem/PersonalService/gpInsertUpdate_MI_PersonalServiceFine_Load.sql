-- Function: gpInsertUpdate_MI_PersonalServiceFine_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalServiceFine_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalServiceFine_Load(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inFIO                 TVarChar  , -- ���
    IN inPositionName        TVarChar  , --
    IN inUnitName            TVarChar  , -- ������������� 
    IN inFineSubjectName     TVarChar  , 
    IN inPersonalServiceListName TVarChar,
    IN inUnitFineSubjectName TVarChar  , 
    IN inComment             TVarChar  ,
    IN inAmount              TFloat    , -- ����� 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbPositionId Integer;
   DECLARE vbPositionId_2 Integer;
   DECLARE vbUnitId Integer; 
   DECLARE vbCodePersonal Integer;
   DECLARE vbMemberId Integer; 
   DECLARE vbMovementItem Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbFineSubjectId Integer;
   DECLARE vbUnitFineSubjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     --RAISE EXCEPTION '��������� <%> �� ������ � ��� = <%> � ������ <%> .', inFIO, inINN, inSummMinusExtRecalc;
     --RAISE EXCEPTION '������. �������� �� ��������';
 
     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� ��������';
     END IF;

     -- ��������
     IF (inFIO = '-' AND COALESCE (inAmount, 0) = 0)
        OR (TRIM (inFIO) = '' AND TRIM (inPersonalServiceListName) = '' AND COALESCE (inAmount, 0) = 0)
     THEN
         RETURN;
     END IF;

     IF TRIM(inFIO) = TRIM('���') OR TRIM(inUnitName) = TRIM('�������������')
     THEN
         RETURN;
     END IF;
     
     -- ��������
     IF COALESCE (inPositionName, '') = ''
     THEN
         RAISE EXCEPTION '������.� <%> <%> �� ����������� ���� <���������> � ����� Excel ��� ����� <%>.', inFIO, inUnitName, inAmount;
     END IF;
     IF COALESCE (inUnitName, '') = ''
     THEN
         RAISE EXCEPTION '������.� <%> <%> �� ����������� ���� <�������������> � ����� Excel ��� ����� <%>.', inFIO, inPositionName, inAmount;
     END IF;     

     -- ����� ���������
     vbPositionId := (SELECT MIN (Object.Id) FROM Object 
                      WHERE Object.DescId = zc_Object_Position() 
                        AND Object.isErased = FALSE
                        AND REPLACE(REPLACE(TRIM (Object.ValueData),'''',''),'`','') LIKE REPLACE(REPLACE(TRIM (inPositionName),'''',''),'`','')
                      );

     -- ����� ���������
     vbPositionId_2 := (SELECT MAX (Object.Id) FROM Object 
                        WHERE Object.DescId = zc_Object_Position() 
                          AND Object.isErased = FALSE
                          AND REPLACE(REPLACE(TRIM (Object.ValueData),'''',''),'`','') LIKE REPLACE(REPLACE(TRIM (inPositionName),'''',''),'`','')
                        );


     -- �������� ���� �� ����� ���������
     IF COALESCE (vbPositionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.� <%> �� ������� <���������> = <%> � �����������.', inFIO, inPositionName;
     END IF;

     -- ������� �������������
     vbUnitId := (SELECT Object.Id
                  FROM Object 
                  WHERE Object.DescId = zc_Object_Unit() 
                    AND Object.isErased = FALSE
                    AND REPLACE (REPLACE(TRIM (Object.ValueData),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inUnitName),'''',''),'`','')
                  ); 
     IF COALESCE (vbUnitId,0) = 0
     THEN
         RAISE EXCEPTION '������.<%> �� ������� � ����������� �������������.', inUnitName;
     END IF;

            
     -- ��������
     IF 1 < (SELECT COUNT(*)
             FROM (SELECT Object_Personal_View.PersonalId
                        , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.MemberId
                                             -- ����������� ������������ ��������� ��� ������, �.�. �������� � Ord = 1
                                             ORDER BY CASE WHEN COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                    , CASE WHEN Object_Personal_View.isOfficial = TRUE THEN 0 ELSE 1 END
                                                    , CASE WHEN Object_Personal_View.isMain = TRUE THEN 0 ELSE 1 END
                                                    , Object_Personal_View.MemberId
                                            ) AS Ord
                   FROM Object_Personal_View
                   WHERE Object_Personal_View.PositionId = vbPositionId
                     AND Object_Personal_View.UnitId = vbUnitId
                     AND Object_Personal_View.isErased = FALSE
                     --AND Object_Personal_View.MemberId = vbMemberId
                     AND REPLACE (REPLACE(TRIM (Object_Personal_View.PersonalName),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','')
                  ) AS tmp
             WHERE tmp.Ord = 1
            )
     THEN
         RAISE EXCEPTION '������.������� ������ ������ ��� ��� <%> <%> <%> (%) (%).', lfGet_Object_ValueData_sh (vbUnitId), inFIO, lfGet_Object_ValueData_sh (vbPositionId), vbUnitId, vbPositionId;
     END IF;

     -- �������
     vbPersonalId := (SELECT tmp.PersonalId
                      FROM (SELECT Object_Personal_View.PersonalId
                                 , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.MemberId
                                                      -- ����������� ������������ ��������� ��� ������, �.�. �������� � Ord = 1
                                                      ORDER BY CASE WHEN COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                             , CASE WHEN Object_Personal_View.isOfficial = TRUE THEN 0 ELSE 1 END
                                                             , CASE WHEN Object_Personal_View.isMain = TRUE THEN 0 ELSE 1 END
                                                             , Object_Personal_View.MemberId
                                                     ) AS Ord
                            FROM Object_Personal_View
                            WHERE Object_Personal_View.PositionId = vbPositionId
                              AND Object_Personal_View.UnitId = vbUnitId
                              --AND Object_Personal_View.MemberId = vbMemberId
                              AND Object_Personal_View.isErased = FALSE
                              AND REPLACE (REPLACE(TRIM (Object_Personal_View.PersonalName),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','')
                           ) AS tmp
                      WHERE tmp.Ord = 1
                     );

     -- ��������
     IF COALESCE (vbPersonalId, 0) = 0
     THEN
         --- ������� ����� � ���������� 2
         vbPersonalId := (SELECT tmp.PersonalId
                          FROM (SELECT Object_Personal_View.PersonalId
                                     , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.MemberId
                                                          -- ����������� ������������ ��������� ��� ������, �.�. �������� � Ord = 1
                                                          ORDER BY CASE WHEN COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                                 , CASE WHEN Object_Personal_View.isOfficial = TRUE THEN 0 ELSE 1 END
                                                                 , CASE WHEN Object_Personal_View.isMain = TRUE THEN 0 ELSE 1 END
                                                                 , Object_Personal_View.MemberId
                                                         ) AS Ord
                                FROM Object_Personal_View
                                WHERE Object_Personal_View.PositionId = vbPositionId_2
                                  AND Object_Personal_View.UnitId = vbUnitId
                                  --AND Object_Personal_View.MemberId = vbMemberId
                                  AND REPLACE (REPLACE(TRIM (Object_Personal_View.PersonalName),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','')
                                ) AS tmp
                          WHERE tmp.Ord = 1
                         );

          -- ���� ����� �� ��������� 2 ��������������
          vbPositionId:= vbPositionId_2;
           
          IF COALESCE (vbPersonalId, 0) = 0
          THEN         
              RAISE EXCEPTION '������.��������� <%> �� ������, ��������� = <%>, ������������� = <%> � ������ <%> .', inFIO, inPositionName, inUnitName, inSummCompensation;
          END IF;
     END IF;

     --������� ��� ����������
     vbFineSubjectId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_FineSubject() AND TRIM (Object.ValueData) ILIKE TRIM (inFineSubjectName));
     IF COALESCE (vbFineSubjectId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ��������� <%> �� ������ ��� ���������� <%> ��������� = <%> � ������ <%> .', inFineSubjectName, inFIO, inPositionName, inAmount;
     END IF;

     --�������
     vbUnitFineSubjectId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND TRIM (Object.ValueData) ILIKE TRIM (inUnitFineSubjectName));
     IF COALESCE (vbUnitFineSubjectId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������������- ��� ���������� ��������� <%> �� ������� ��� ���������� <%> ��������� = <%> � ������ <%> .', inUnitFineSubjectName, inFIO, inPositionName, inAmount;
     END IF;

      --������� ��������� ��� �������������
     vbPersonalServiceListId := (WITH tmpObject AS (SELECT Object.* FROM Object WHERE Object.DescId = zc_Object_PersonalServiceList())
                                 SELECT Object.Id FROM tmpObject AS Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPersonalServiceListName)
                                );
     IF COALESCE (vbPersonalServiceListId, 0) = 0
     THEN
         vbPersonalServiceListId := (WITH tmpObject AS (SELECT Object.* FROM Object WHERE Object.DescId = zc_Object_PersonalServiceList())
                                     SELECT Object.Id FROM tmpObject AS Object WHERE REPLACE (TRIM (Object.ValueData), CHR(39), '`') ILIKE REPLACE (TRIM (inPersonalServiceListName), CHR(39), '`')
                                    );
     END IF;
     IF COALESCE (vbPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��������� <%> �� ������� ��� ���������� <%> ��������� = <%> � ������ <%> .', inPersonalServiceListName, inFIO, inPositionName, inAmount;
     END IF;


     -- ��������� , � ������ ���� ���������� �� ���� � ��������� �������� ���
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := COALESCE (gpSelect.Id,0)
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := tmpPersonal.PersonalId
                                                        , inIsMain             := COALESCE (gpSelect.IsMain, tmpPersonal.IsMain)
                                                        , inSummService        := COALESCE (gpSelect.SummService, 0)
                                                        , inSummCardRecalc     := COALESCE (gpSelect.SummCardRecalc, 0)
                                                        , inSummCardSecondRecalc:= 0
                                                        , inSummCardSecondCash := COALESCE (gpSelect.SummCardSecondCash,0)
                                                        , inSummNalogRecalc    := COALESCE (gpSelect.SummNalogRecalc, 0)
                                                        , inSummNalogRetRecalc := 0
                                                        , inSummMinus          := COALESCE (gpSelect.SummMinus, 0)
                                                        , inSummAdd            := COALESCE (gpSelect.SummAdd, 0)
                                                        , inSummAddOthRecalc   := COALESCE (gpSelect.SummAddOthRecalc, 0)
                                                        , inSummHoliday        := COALESCE (gpSelect.SummHoliday, 0)
                                                        , inSummSocialIn       := COALESCE (gpSelect.SummSocialIn, 0)
                                                        , inSummSocialAdd      := COALESCE (gpSelect.SummSocialAdd, 0)
                                                        , inSummChildRecalc    := COALESCE (gpSelect.SummChildRecalc, 0)
                                                        , inSummMinusExtRecalc := COALESCE (gpSelect.SummMinusExtRecalc, 0)
                                                        , inSummFine           := COALESCE (gpSelect.SummFine, 0)
                                                        , inSummFineOthRecalc  := inAmount ::TFloat
                                                        , inSummHosp           := COALESCE (gpSelect.SummHosp, 0)
                                                        , inSummHospOthRecalc  := COALESCE (gpSelect.SummHospOthRecalc, 0)
                                                        , inSummCompensationRecalc := COALESCE (gpSelect.SummCompensationRecalc, 0)
                                                        , inSummAuditAdd       := COALESCE (gpSelect.SummAuditAdd,0)
                                                        , inSummHouseAdd       := COALESCE (gpSelect.SummHouseAdd,0)
                                                        , inSummAvanceRecalc   := COALESCE (gpSelect.SummAvance,0)
                                                        , inNumber             := COALESCE (gpSelect.Number, '')
                                                        , inComment            := COALESCE (inComment, '') ::TVarChar
                                                        , inInfoMoneyId        := COALESCE (gpSelect.InfoMoneyId, zc_Enum_InfoMoney_60101()) -- 60101 ���������� ����� + ���������� �����
                                                        , inUnitId             := tmpPersonal.UnitId
                                                        , inPositionId         := tmpPersonal.PositionId
                                                        , inMemberId               := gpSelect.MemberId                                   
                                                        , inPersonalServiceListId  := vbPersonalServiceListId ::Integer
                                                        , inFineSubjectId          := vbFineSubjectId     ::Integer
                                                        , inUnitFineSubjectId      := vbUnitFineSubjectId ::Integer
                                                        , inUserId           :=vbUserId
                                                         )
      FROM (SELECT View_Personal.PersonalId
                 , View_Personal.UnitId
                 , View_Personal.PositionId
                 , View_Personal.IsMain
            FROM Object_Personal_View AS View_Personal
            WHERE View_Personal.PersonalId = vbPersonalId
           ) AS tmpPersonal
           LEFT JOIN gpSelect_MovementItem_PersonalService (inMovementId, FALSE, FALSE, inSession) AS gpSelect
                                                                                                   ON gpSelect.PersonalId = tmpPersonal.PersonalId
                                                                                                  AND gpSelect.FineSubjectId = vbFineSubjectId
                                                                                                  AND gpSelect.UnitFineSubjectId = vbUnitFineSubjectId
                                                                                                  AND COALESCE (gpSelect.Comment, '') = COALESCE (inComment, '')
      LIMIT 1;      


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  
 06.06.23         *
*/

-- ����
--
