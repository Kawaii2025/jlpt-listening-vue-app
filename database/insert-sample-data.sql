-- 插入试卷
INSERT INTO exams (name, year, session, level) VALUES
('JLPT N1 Practice Test', 2024, '1', 'N1');

-- 获取exam_id（假设只有一条记录）
WITH exam AS (SELECT id FROM exams WHERE level = 'N1' LIMIT 1)

-- 第一大题：課題理解（短对话）
INSERT INTO parts (exam_id, part_name, part_num, order_num) 
SELECT id, '課題理解', 1, 1 FROM exam;

-- 获取第一大题的ID并插入题目
WITH exam AS (SELECT id FROM exams WHERE level = 'N1' LIMIT 1),
part1 AS (SELECT id FROM parts WHERE part_num = 1 AND exam_id IN (SELECT id FROM exam) LIMIT 1)

INSERT INTO items (part_id, content, item_num, order_num) VALUES
((SELECT id FROM part1), '女の人と男の人が話しています。二人の関係はどうですか？', 1, 1),
((SELECT id FROM part1), '男の人と女の人が駅で話しています。男の人はこれからどこに行きますか？', 2, 2),
((SELECT id FROM part1), '女の人が男の人に説明しています。その内容は何についてですか？', 3, 3);

-- 第1大題の選択肢
WITH item1 AS (SELECT id FROM items WHERE item_num = 1 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item1), 'A', '同僚', FALSE, 1),
((SELECT id FROM item1), 'B', '上司と部下', TRUE, 2),
((SELECT id FROM item1), 'C', '夫婦', FALSE, 3),
((SELECT id FROM item1), 'D', '知り合い', FALSE, 4);

WITH item2 AS (SELECT id FROM items WHERE item_num = 2 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item2), 'A', '空港', FALSE, 1),
((SELECT id FROM item2), 'B', '病院', FALSE, 2),
((SELECT id FROM item2), 'C', '会社', TRUE, 3),
((SELECT id FROM item2), 'D', '図書館', FALSE, 4);

WITH item3 AS (SELECT id FROM items WHERE item_num = 3 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item3), 'A', '新しいプロジェクトについて', TRUE, 1),
((SELECT id FROM item3), 'B', '休暇の計画について', FALSE, 2),
((SELECT id FROM item3), 'C', '引越しについて', FALSE, 3),
((SELECT id FROM item3), 'D', '結婚式について', FALSE, 4);

-- 第1大題の聴解スクリプト
WITH item1 AS (SELECT id FROM items WHERE item_num = 1 LIMIT 1)
INSERT INTO sentences (item_id, text, order_num) VALUES
((SELECT id FROM item1), '男：「佐藤さん、この企画書、見ていただけますか？」', 1),
((SELECT id FROM item1), '女：「ええ、わかりました。明日までに目を通しておきます。」', 2);

WITH item2 AS (SELECT id FROM items WHERE item_num = 2 LIMIT 1)
INSERT INTO sentences (item_id, text, order_num) VALUES
((SELECT id FROM item2), '女：「お疲れ様です。これからどちらへ？」', 1),
((SELECT id FROM item2), '男：「ええ、実は大事な会議があるんで、会社に戻らなくちゃならないんです。」', 2);

WITH item3 AS (SELECT id FROM items WHERE item_num = 3 LIMIT 1)
INSERT INTO sentences (item_id, text, order_num) VALUES
((SELECT id FROM item3), '女：「来月からの新プロジェクトについて説明させていただきます。」', 1),
((SELECT id FROM item3), '女：「今回は市場分析から始めて、その後戦略を立てていく予定です。」', 2);

-- 第二大題：ポイント理解（中等対話）
INSERT INTO parts (exam_id, part_name, part_num, order_num)
SELECT id, 'ポイント理解', 2, 2 FROM exams WHERE level = 'N1' LIMIT 1;

WITH exam AS (SELECT id FROM exams WHERE level = 'N1' LIMIT 1),
part2 AS (SELECT id FROM parts WHERE part_num = 2 AND exam_id IN (SELECT id FROM exam) LIMIT 1)

INSERT INTO items (part_id, content, item_num, order_num) VALUES
((SELECT id FROM part2), '女の人がカフェで男の人に何か勧めています。女の人は何を勧めていますか？', 1, 1),
((SELECT id FROM part2), '男の人が店員に商品について質問しています。その商品の特徴は何ですか？', 2, 2);

WITH item4 AS (SELECT id FROM items WHERE part_id = (SELECT id FROM parts WHERE part_num = 2 LIMIT 1) AND item_num = 1 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item4), 'A', 'コーヒー', FALSE, 1),
((SELECT id FROM item4), 'B', '新しいケーキ', TRUE, 2),
((SELECT id FROM item4), 'C', 'アイスクリーム', FALSE, 3),
((SELECT id FROM item4), 'D', 'ジュース', FALSE, 4);

WITH item5 AS (SELECT id FROM items WHERE part_id = (SELECT id FROM parts WHERE part_num = 2 LIMIT 1) AND item_num = 2 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item5), 'A', '値段が安い', FALSE, 1),
((SELECT id FROM item5), 'B', '長く使える', TRUE, 2),
((SELECT id FROM item5), 'C', '軽くて持ちやすい', FALSE, 3),
((SELECT id FROM item5), 'D', 'デザインがいい', FALSE, 4);

-- 第三大題：概況理解（長めの話）
INSERT INTO parts (exam_id, part_name, part_num, order_num)
SELECT id, '概況理解', 3, 3 FROM exams WHERE level = 'N1' LIMIT 1;

WITH exam AS (SELECT id FROM exams WHERE level = 'N1' LIMIT 1),
part3 AS (SELECT id FROM parts WHERE part_num = 3 AND exam_id IN (SELECT id FROM exam) LIMIT 1)

INSERT INTO items (part_id, content, item_num, order_num) VALUES
((SELECT id FROM part3), 'アナウンサーが新しい技術について説明しています。その技術の利点は何ですか？', 1, 1);

WITH item6 AS (SELECT id FROM items WHERE part_id = (SELECT id FROM parts WHERE part_num = 3 LIMIT 1) AND item_num = 1 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item6), 'A', 'エネルギー効率が高い', TRUE, 1),
((SELECT id FROM item6), 'B', 'インストールが簡単', FALSE, 2),
((SELECT id FROM item6), 'C', '価格が安い', FALSE, 3),
((SELECT id FROM item6), 'D', 'サイズが小さい', FALSE, 4);

-- 第四大題：即時応答（短い応答）
INSERT INTO parts (exam_id, part_name, part_num, order_num)
SELECT id, '即時応答', 4, 4 FROM exams WHERE level = 'N1' LIMIT 1;

WITH exam AS (SELECT id FROM exams WHERE level = 'N1' LIMIT 1),
part4 AS (SELECT id FROM parts WHERE part_num = 4 AND exam_id IN (SELECT id FROM exam) LIMIT 1)

INSERT INTO items (part_id, content, item_num, order_num) VALUES
((SELECT id FROM part4), '「最近、仕事が忙しくて、全然休めていないんです。」と言われた時、何と答えますか？', 1, 1),
((SELECT id FROM part4), '「このプロジェクト、いつまでに完成させればいいですか？」と聞かれた時、何と答えますか？', 2, 2);

WITH item7 AS (SELECT id FROM items WHERE part_id = (SELECT id FROM parts WHERE part_num = 4 LIMIT 1) AND item_num = 1 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item7), 'A', 'そうですか。大変ですね。', TRUE, 1),
((SELECT id FROM item7), 'B', '私も同じです。', FALSE, 2),
((SELECT id FROM item7), 'C', 'それは本当に申し訳ない。', FALSE, 3),
((SELECT id FROM item7), 'D', 'もっと頑張ってください。', FALSE, 4);

WITH item8 AS (SELECT id FROM items WHERE part_id = (SELECT id FROM parts WHERE part_num = 4 LIMIT 1) AND item_num = 2 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item8), 'A', 'まあ、いつでもいいですよ。', FALSE, 1),
((SELECT id FROM item8), 'B', '来月末までにお願いします。', TRUE, 2),
((SELECT id FROM item8), 'C', 'もう完成しています。', FALSE, 3),
((SELECT id FROM item8), 'D', 'わかりません。', FALSE, 4);

-- 第五大題：統合理解（最も長い、複雑な話）
INSERT INTO parts (exam_id, part_name, part_num, order_num)
SELECT id, '統合理解', 5, 5 FROM exams WHERE level = 'N1' LIMIT 1;

WITH exam AS (SELECT id FROM exams WHERE level = 'N1' LIMIT 1),
part5 AS (SELECT id FROM parts WHERE part_num = 5 AND exam_id IN (SELECT id FROM exam) LIMIT 1)

INSERT INTO items (part_id, content, item_num, order_num) VALUES
((SELECT id FROM part5), '長めの講演について複数の質問が出されます。以下、最初の質問です：講演者が最も強調していたポイントは何ですか？', 1, 1),
((SELECT id FROM part5), '講演者は今後の計画について何と述べていますか？', 2, 2);

WITH item9 AS (SELECT id FROM items WHERE part_id = (SELECT id FROM parts WHERE part_num = 5 LIMIT 1) AND item_num = 1 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item9), 'A', '過去の経験が大切', FALSE, 1),
((SELECT id FROM item9), 'B', 'グローバルな視点が重要', TRUE, 2),
((SELECT id FROM item9), 'C', '技術的なスキルのみ必要', FALSE, 3),
((SELECT id FROM item9), 'D', '年齢は関係ない', FALSE, 4);

WITH item10 AS (SELECT id FROM items WHERE part_id = (SELECT id FROM parts WHERE part_num = 5 LIMIT 1) AND item_num = 2 LIMIT 1)
INSERT INTO choices (item_id, choice_label, choice_content, is_correct, order_num) VALUES
((SELECT id FROM item10), 'A', '現在のプロジェクトを継続する', FALSE, 1),
((SELECT id FROM item10), 'B', '新しい事業分野に挑戦する', TRUE, 2),
((SELECT id FROM item10), 'C', '海外拠点を閉鎖する', FALSE, 3),
((SELECT id FROM item10), 'D', 'チームを縮小する', FALSE, 4);
