-- Trigger: trigger_notify_changes_container on public.container

DROP TRIGGER IF EXISTS trigger_notify_changes_container ON public.container;

CREATE TRIGGER trigger_notify_changes_container
  BEFORE INSERT OR UPDATE OR DELETE
  ON public.container
  FOR EACH ROW
  EXECUTE PROCEDURE _replica.notice_changed_data_container();
