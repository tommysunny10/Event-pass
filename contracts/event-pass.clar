;; ------------------------------------------------
;; Contract: event-pass
;; Trustless On-Chain Event Ticketing & Access System
;; ------------------------------------------------

(define-constant ERR_NOT_ADMIN (err u100))
(define-constant ERR_NOT_FOUND (err u101))
(define-constant ERR_SOLD_OUT (err u102))
(define-constant ERR_ALREADY_HAS_TICKET (err u103))
(define-constant ERR_EVENT_CANCELED (err u104))

;; Contract owner (super admin)
(define-data-var contract-owner principal tx-sender)

;; Event data structure
(define-map events
  { id: uint }
  { organizer: principal,
    title: (string-ascii 50),
    date: (string-ascii 20),
    ticket-price: uint,
    total-tickets: uint,
    tickets-sold: uint,
    canceled: bool })

(define-data-var event-counter uint u0)

;; Tickets (NFT-like but simple mapping)
(define-map tickets
  { event-id: uint, holder: principal }
  { valid: bool })

;; ------------------------------
;; Event Functions
;; ------------------------------

;; Create a new event
(define-public (create-event (title (string-ascii 50)) (date (string-ascii 20)) (ticket-price uint) (total-tickets uint))
  (begin
    (var-set event-counter (+ (var-get event-counter) u1))
    (map-set events { id: (var-get event-counter) }
      { organizer: tx-sender,
        title: title,
        date: date,
        ticket-price: ticket-price,
        total-tickets: total-tickets,
        tickets-sold: u0,
        canceled: false })
    (ok (var-get event-counter))))

;; Cancel an event (only organizer)
(define-public (cancel-event (event-id uint))
  (let ((ev (unwrap! (map-get? events { id: event-id }) ERR_NOT_FOUND)))
    (if (is-eq tx-sender (get organizer ev))
        (begin
          (map-set events { id: event-id }
            (merge ev { canceled: true }))
          (ok true))
        ERR_NOT_ADMIN)))

;; ------------------------------
;; Ticket Functions
;; ------------------------------

;; Buy a ticket
(define-public (buy-ticket (event-id uint))
  (let ((e (unwrap! (map-get? events { id: event-id }) ERR_NOT_FOUND)))
    ;; Logic Checks
    (asserts! (not (get canceled e)) ERR_EVENT_CANCELED)
    (asserts! (< (get tickets-sold e) (get total-tickets e)) ERR_SOLD_OUT)
    (asserts! (is-none (map-get? tickets { event-id: event-id, holder: tx-sender })) ERR_ALREADY_HAS_TICKET)
    
    ;; Execute Payment
    (try! (stx-transfer? (get ticket-price e) tx-sender (get organizer e)))
    
    ;; Update State
    (begin
      (map-set tickets { event-id: event-id, holder: tx-sender } { valid: true })
      (map-set events { id: event-id }
        (merge e { tickets-sold: (+ (get tickets-sold e) u1) }))
      (ok true))))

;; Verify ticket
(define-read-only (verify-ticket (event-id uint) (user principal))
  (match (map-get? tickets { event-id: event-id, holder: user })
    t (ok (get valid t))
    ERR_NOT_FOUND))

;; ------------------------------
;; Read-Only Helpers
;; ------------------------------

(define-read-only (get-event (event-id uint))
  (map-get? events { id: event-id }))

(define-read-only (has-ticket (event-id uint) (user principal))
  (map-get? tickets { event-id: event-id, holder: user }))