
(ns app.style.layout )

(def workspace
  {:grid {:display "grid",
          :grid-template-rows "60px 1fr",
          :grid-template-columns "1fr",
          :grid-gap "16px",
          :justify-items :stretch,
          :align-items :stretch},
   :header {:grid-area "1/1"},
   :body {:grid-area 2/1}})

(def header
  {:grid {:display :grid,
          :grid-template-rows "1fr",
          :grid-template-columns "80px 1fr 80px",
          :grid-gap "8px",
          :align-items :center,
          :justify-items :center},
   :logo {:grid-area "1/1"},
   :profile {:grid-area "1/4"}})

(def editor
  {:grid {:display :grid,
          :grid-template-columns "repeat(6,1fr)",
          :grid-template-row "repeat(4,1fr)",
          :grid-gap "8px",
          :justify-items :stretch,
          :align-items :stretch},
   :modules {:grid-area "1/4/span 1/span 2"},
   :preview {:grid-area "1/1/span 4/span 3"},
   :tree {:grid-area "2/4/span 3/span 2"},
   :props {:grid-area "1/6/span 2/span 1"},
   :style {:grid-area "3/6/span 2/span 1"}})

(def modules-panel
  {:grid {:display :grid,
          :justify-items :stretch,
          :align-items :stretch,
          :grid-template-rows "1fr",
          :grid-template-columns "1fr 1fr",
          :grid-gap "8px"},
   :list {:grid-area "1/1"},
   :control {:grid-area "1/2"}})
