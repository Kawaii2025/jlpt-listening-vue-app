-- 试卷表
CREATE TABLE exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    year INTEGER,
    session VARCHAR(10),
    level VARCHAR(10),
    created_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai'),
    updated_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai')
);

-- 大题表
CREATE TABLE parts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id UUID REFERENCES exams(id) ON DELETE CASCADE,
    part_name VARCHAR(100),
    part_num INTEGER,
    order_num INTEGER,
    created_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai'),
    updated_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai')
);

-- 小题表
CREATE TABLE items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    part_id UUID REFERENCES parts(id) ON DELETE CASCADE,
    content TEXT,
    item_num INTEGER,
    order_num INTEGER,
    created_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai'),
    updated_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai')
);

-- 选项表
CREATE TABLE choices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID REFERENCES items(id) ON DELETE CASCADE,
    choice_label VARCHAR(10),
    choice_content TEXT,
    is_correct BOOLEAN DEFAULT FALSE,
    order_num INTEGER,
    created_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai'),
    updated_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai')
);

-- 听力句子表
CREATE TABLE sentences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID REFERENCES items(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    order_num INTEGER,
    created_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai'),
    updated_at TIMESTAMP DEFAULT (now() AT TIME ZONE 'Asia/Shanghai')
);

-- 用户表
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 用户练习记录表
CREATE TABLE user_practice (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    sentence_id UUID REFERENCES sentences(id) ON DELETE CASCADE,
    practiced_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
