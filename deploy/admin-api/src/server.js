const express = require("express");
const mysql = require("mysql2/promise");
const app = express();
const PORT = process.env.PORT || 8080;

app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", "https://admin.kim-test.shop");
    res.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type");
    if (req.method === "OPTIONS") {
        return res.sendStatus(204);
    }
    next();
});

const requiredEnvs = ["DB_HOST", "DB_PORT", "DB_NAME", "DB_USER", "DB_PASSWORD"];

for (const envName of requiredEnvs) {
    if (!process.env[envName]) {
        console.warn(`[WARN] Missing environment variable: ${envName}`);
    }
}

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 3306),
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    waitForConnections: true,
    connectionLimit: 5,
    queueLimit: 0,
    connectTimeout: 3000
});

app.use(express.json());

app.use((req, res, next) => {
    const startedAt = Date.now();

    res.on("finish", () => {
        // Kubernetes Probe 요청은 로그에서 제외
        if (req.path === "/live" || req.path === "/ready") {
            return;
        }

        console.log(
            JSON.stringify({
                timestamp: new Date().toISOString(),
                method: req.method,
                path: req.originalUrl,
                status: res.statusCode,
                durationMs: Date.now() - startedAt
            })
        );
    });

    next();
});

app.get("/", (req, res) => {
    res.status(200).json({
        service: "admin-api",
        status: "running"
    });
});

app.get("/live", (req, res) => {
    res.status(200).json({
        status: "UP",
        service: "admin-api",
        check: "liveness"
    });
});

app.get("/ready", async (req, res) => {
    try {
        await pool.query("SELECT 1");
        res.status(200).json({
            status: "READY",
            db: "connected"
        });
    } catch (err) {
        console.error("[READY_CHECK_FAILED]", err.message);

        res.status(503).json({
            status: "NOT_READY",
            db: "disconnected",
            error: err.message
        });
    }
});
app.get("/db-test", async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT NOW() AS db_time");

        res.status(200).json({
            message: "DB connection success",
            result: rows
        });
    } catch (err) {
        console.error("[DB_TEST_FAILED]", err.message);

        res.status(500).json({
            message: "DB connection failed",
            error: err.message
        });
    }
});

app.get("/error", (req, res) => {
    res.status(500).send("test 500 error");
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`admin-api listening on port ${PORT}`);
});