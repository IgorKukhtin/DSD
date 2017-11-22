-- Function: zfCalc_StatDayCount_Week()

DROP FUNCTION IF EXISTS zfCalc_StatDayCount_Week (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_StatDayCount_Week (
    IN inAmount            TFloat   , -- �������, ����� ���� ������
    IN inAmountPartnerNext TFloat   , -- "������������" ����� ���������� + �����, ������
    IN inCountForecast     TFloat   , -- "�������" �� 1 ���� - ������� ��� ������ ��� �����
    IN inPlan1             TFloat   , -- ����� ���������� + �����, +1 ����
    IN inPlan2             TFloat   , -- ����� ���������� + �����, +2 ����
    IN inPlan3             TFloat   , -- ����� ���������� + �����, +3 ����
    IN inPlan4             TFloat   , -- ����� ���������� + �����, +4 ����
    IN inPlan5             TFloat   , -- ����� ���������� + �����, +5 ����
    IN inPlan6             TFloat   , -- ����� ���������� + �����, +6 ����
    IN inPlan7             TFloat     -- ����� ���������� + �����, +7 ����
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbRes TFloat;
BEGIN

      -- ����������� ���� �� 1-�� ����, �.�. � ��� ���� 90% �����
      IF inPlan1 < inAmountPartnerNext THEN inPlan1:= inAmountPartnerNext; END IF;


      -- ���� ������� "������������" � ��� ����� �� �������
      IF inAmount + inAmountPartnerNext <= 0 OR COALESCE (inCountForecast, 0) = 0
      THEN -- ����� ����
           vbRes:= 0;

      -- ���� ������� ������ 8 ����
      ELSEIF inAmount >= inCountForecast * 8 AND inCountForecast > 0
      THEN -- ����� �� ������ �����
           vbRes:= (inAmount) / inCountForecast;

      -- ���� ������� ������ ��� ���� �� 1-�� ����
      ELSEIF inAmount + inAmountPartnerNext <= inPlan1
      THEN -- ����� ��������� ����� ���������� + �����, ������
           vbRes:= (inAmount + inAmountPartnerNext) / inPlan1;

      ELSE
          -- ����������, �� 1-�� ���� ������ �������
          vbRes:= 1;

          -- �������� ����� 1-��� ���
          inAmount:= inAmount + inAmountPartnerNext - inPlan1;
          -- ��������
          IF inAmount < 0 THEN RETURN (-1); RAISE EXCEPTION '������.�������� ����� ��� = <%> ���-�� = <%>', vbRes, inAmount; END IF;

          WHILE inAmount > 0
          LOOP
              -- ���� ������� ������ ��� ���� �� vbRes + 1 ����
              IF inAmount <= (CASE vbRes WHEN 1 THEN inPlan2
                                         WHEN 2 THEN inPlan3
                                         WHEN 3 THEN inPlan4
                                         WHEN 4 THEN inPlan5
                                         WHEN 5 THEN inPlan6
                                         WHEN 6 THEN inPlan7
                                         WHEN 7 THEN inPlan1
                                         WHEN 8 THEN inPlan2
                                         WHEN 9 THEN inPlan3
                                         WHEN 10 THEN inPlan4
                                         WHEN 11 THEN inPlan5
                                         WHEN 12 THEN inPlan6
                                         WHEN 13 THEN inPlan7
                                         WHEN 14 THEN inPlan1
                                         WHEN 15 THEN inPlan2
                                         ELSE inCountForecast
                              END)

              THEN -- ����� ��������� ���� ������� � ���.
                   vbRes:= vbRes + inAmount / CASE vbRes WHEN 1 THEN inPlan2
                                                         WHEN 2 THEN inPlan3
                                                         WHEN 3 THEN inPlan4
                                                         WHEN 4 THEN inPlan5
                                                         WHEN 5 THEN inPlan6
                                                         WHEN 6 THEN inPlan7
                                                         WHEN 7 THEN inPlan1
                                                         WHEN 8 THEN inPlan2
                                                         WHEN 10 THEN inPlan4
                                                         WHEN 11 THEN inPlan5
                                                         WHEN 12 THEN inPlan6
                                                         WHEN 13 THEN inPlan7
                                                         WHEN 14 THEN inPlan1
                                                         WHEN 15 THEN inPlan2
                                                         WHEN 9 THEN inPlan3
                                                         ELSE inCountForecast
                                              END;
                  -- �������� �������
                  inAmount:= 0;
              ELSE
                  -- ������� - ��������� �������
                  inAmount:= inAmount - CASE vbRes WHEN 1 THEN inPlan2
                                                   WHEN 2 THEN inPlan3
                                                   WHEN 3 THEN inPlan4
                                                   WHEN 4 THEN inPlan5
                                                   WHEN 5 THEN inPlan6
                                                   WHEN 6 THEN inPlan7
                                                   WHEN 7 THEN inPlan1
                                                   WHEN 8 THEN inPlan2
                                                   WHEN 9 THEN inPlan3
                                                   WHEN 10 THEN inPlan4
                                                   WHEN 11 THEN inPlan5
                                                   WHEN 12 THEN inPlan6
                                                   WHEN 13 THEN inPlan7
                                                   WHEN 14 THEN inPlan1
                                                   WHEN 15 THEN inPlan2
                                                   ELSE inCountForecast
                                        END;

                  -- ����������, �.�. �� ���� vbRes + 1 ������� �������
                  vbRes:= vbRes + 1;


              END IF;

              -- ��������
              IF inAmount < 0 THEN RETURN (-2); RAISE EXCEPTION '������.�������� ����� ��� = <%> ���-�� = <%>', vbRes, inAmount; END IF;
              -- ��������
              IF vbRes > 15 THEN RETURN (-3); RAISE EXCEPTION '������.������� ����� ���� = <%> ���-�� = <%>', vbRes, inAmount; END IF;

          END LOOP;


      END IF;

      RETURN CAST (vbRes AS NUMERIC (16, 1));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 22.11.17                                        *
*/

-- ����
-- SELECT * FROM zfCalc_StatDayCount_Week (inAmount:= 3, inAmountPartnerNext:= 0, inCountForecast:= 200, inPlan1:= 7, inPlan2:= 6, inPlan3:= 5, inPlan4:= 4, inPlan5:= 3, inPlan6:= 2, inPlan7:= 1)
