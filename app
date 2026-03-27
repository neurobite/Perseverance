import React, { useState, useEffect } from "react";

export default function ZenApp() {
  const [stones, setStones] = useState([]);
  const [hasCompletedToday, setHasCompletedToday] = useState(false);
  const [streak, setStreak] = useState(0);

  useEffect(() => {
    const saved = JSON.parse(localStorage.getItem("zenPersevere")) || {};
    setStones(saved.stones || []);
    setStreak(saved.streak || 0);
    if (saved.lastDate === new Date().toDateString())
      setHasCompletedToday(true);
  }, []);

  const addStone = () => {
    if (hasCompletedToday) return;

    // Physical Feedback (Android)
    if (navigator.vibrate) navigator.vibrate([40, 20, 40]);

    const riverColors = [
      "radial-gradient(circle at 30% 30%, #a3a3a3, #525252)", // Slate
      "radial-gradient(circle at 30% 30%, #8b9a8e, #4a5d4e)", // Moss
      "radial-gradient(circle at 30% 30%, #c4a484, #7a5c3e)", // Clay
      "radial-gradient(circle at 30% 30%, #94a3b8, #334155)", // River Blue
      "radial-gradient(circle at 30% 30%, #d1d5db, #6b7280)", // Granite
    ];

    const newStone = {
      id: Date.now(),
      background: riverColors[Math.floor(Math.random() * riverColors.length)],
      left: Math.floor(Math.random() * 55) + 20,
      rotate: Math.floor(Math.random() * 360),
      size: Math.floor(Math.random() * 10) + 40, // Varied stone sizes
    };

    const updatedStones = [...stones, newStone];
    const newStreak = streak + 1;

    setStones(updatedStones);
    setStreak(newStreak);
    setHasCompletedToday(true);

    localStorage.setItem(
      "zenPersevere",
      JSON.stringify({
        stones: updatedStones,
        lastDate: new Date().toDateString(),
        streak: newStreak,
      })
    );
  };

  return (
    <div style={styles.canvas}>
      <style>{`
        @keyframes fall {
          0% { transform: translateY(-400px) scale(1.1); opacity: 0; }
          70% { transform: translateY(0) scale(1); opacity: 1; }
          85% { transform: translateY(-8px); }
          100% { transform: translateY(0); }
        }
        .stone { animation: fall 0.9s cubic-bezier(0.22, 1, 0.36, 1) forwards; }
        .zen-btn:active { box-shadow: inset 6px 6px 12px #d1cfc9, inset -6px -6px 12px #ffffff !important; transform: scale(0.98); }
      `}</style>

      {/* TOP SECTION: NEOMORPHIC BUTTON */}
      <div style={styles.topNav}>
        <button
          onClick={addStone}
          className="zen-btn"
          disabled={hasCompletedToday}
          style={{
            ...styles.button,
            color: hasCompletedToday ? "#a3a3a3" : "#6b7280",
            cursor: hasCompletedToday ? "default" : "pointer",
          }}
        >
          {hasCompletedToday ? "PEACE ATTAINED" : "PLACE STONE"}
        </button>
        <div style={styles.streakCount}>STREAK: {streak} DAYS</div>
      </div>

      {/* MAIN SECTION: THE BASIN */}
      <div style={styles.gardenFrame}>
        <div style={styles.basin}>
          {stones.map((stone, i) => (
            <div
              key={stone.id}
              className="stone"
              style={{
                ...styles.pebble,
                background: stone.background,
                left: `${stone.left}%`,
                width: stone.size,
                height: stone.size,
                bottom: `${Math.floor(i / 3) * 30 + 20}px`,
                transform: `rotate(${stone.rotate}deg)`,
                zIndex: i,
              }}
            />
          ))}
          {/* Inner basin shadow for 3D depth */}
          <div style={styles.basinInnerShadow} />
        </div>
      </div>

      <div style={styles.footer}>
        {stones.length} / 7 STONES THIS WEEK
        <div
          onClick={() => {
            if (confirm("Reset?")) {
              localStorage.clear();
              location.reload();
            }
          }}
          style={{ marginTop: "20px", opacity: 0.3 }}
        >
          Clear Garden
        </div>
      </div>
    </div>
  );
}

const styles = {
  canvas: {
    backgroundColor: "#e6e3dc", // Soft sand color
    minHeight: "100vh",
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    fontFamily: "'Segoe UI', Roboto, sans-serif",
    padding: "40px 20px",
    overflow: "hidden",
  },
  topNav: {
    width: "100%",
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    marginBottom: "40px",
  },
  button: {
    width: "200px",
    height: "200px",
    borderRadius: "50%",
    border: "none",
    background: "#e6e3dc",
    // 3D Neomorphic Shadow
    boxShadow: "10px 10px 20px #c4c1bb, -10px -10px 20px #ffffff",
    fontSize: "12px",
    fontWeight: "bold",
    letterSpacing: "2px",
    transition: "all 0.3s ease",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    textAlign: "center",
    padding: "20px",
  },
  streakCount: {
    marginTop: "25px",
    fontSize: "11px",
    letterSpacing: "3px",
    color: "#8b8881",
  },
  gardenFrame: {
    position: "relative",
    width: "100%",
    maxWidth: "320px",
    display: "flex",
    justifyContent: "center",
  },
  basin: {
    position: "relative",
    width: "260px",
    height: "320px",
    backgroundColor: "#dfdbd2",
    borderRadius: "130px 130px 60px 60px",
    border: "8px solid #ece9e2",
    boxShadow: "inset 10px 10px 20px #c4c1bb, inset -10px -10px 20px #ffffff",
    overflow: "hidden",
  },
  basinInnerShadow: {
    position: "absolute",
    inset: 0,
    background: "linear-gradient(180deg, rgba(0,0,0,0.05) 0%, transparent 40%)",
    pointerEvents: "none",
  },
  pebble: {
    position: "absolute",
    borderRadius: "45% 55% 50% 50% / 50% 50% 55% 45%", // Organic stone shape
    boxShadow:
      "2px 5px 10px rgba(0,0,0,0.3), inset -2px -2px 5px rgba(0,0,0,0.2)",
    border: "1px solid rgba(255,255,255,0.1)",
  },
  footer: {
    marginTop: "auto",
    padding: "40px",
    fontSize: "10px",
    letterSpacing: "4px",
    color: "#8b8881",
    textAlign: "center",
  },
};
