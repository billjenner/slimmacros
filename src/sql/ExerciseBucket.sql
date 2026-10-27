-- Private bucket for exercise videos (video_path stores the object path in this bucket)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('exercise-videos', 'exercise-videos', false, 52428800, ARRAY['video/*'])
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "Authenticated can read exercise videos" ON storage.objects;
CREATE POLICY "Authenticated can read exercise videos"
ON storage.objects FOR SELECT TO authenticated
USING (bucket_id = 'exercise-videos');

DROP POLICY IF EXISTS "Authenticated can upload exercise videos" ON storage.objects;
CREATE POLICY "Authenticated can upload exercise videos"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'exercise-videos');

DROP POLICY IF EXISTS "Authenticated can update exercise videos" ON storage.objects;
CREATE POLICY "Authenticated can update exercise videos"
ON storage.objects FOR UPDATE TO authenticated
USING (bucket_id = 'exercise-videos');

DROP POLICY IF EXISTS "Authenticated can delete exercise videos" ON storage.objects;
CREATE POLICY "Authenticated can delete exercise videos"
ON storage.objects FOR DELETE TO authenticated
USING (bucket_id = 'exercise-videos');
