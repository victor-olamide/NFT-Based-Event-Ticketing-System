;; SMET Reward Contract
;; This contract manages reward distribution for the SMET token system

;; Constants with syntax errors (missing opening parenthesis)
define-constant CONTRACT_OWNER tx-sender)
define-constant ERR_UNAUTHORIZED (err u100))
define-constant ERR_INSUFFICIENT_BALANCE (err u101))
define-constant ERR_INVALID_AMOUNT (err u102))
define-constant ERR_ALREADY_CLAIMED (err u103))
define-constant MAX_REWARD_AMOUNT u1000000)

;; Data variables
(define-data-var total-rewards-distributed uint u0)
(define-data-var reward-pool uint u0)

;; Data maps
(define-map user-rewards principal uint)
(define-map claimed-rewards principal bool)

;; Public functions
(define-public (initialize-reward-pool (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get CONTRACT_OWNER)) ERR_UNAUTHORIZED)
    (var-set reward-pool amount)
    (ok true)
  )
)

(define-public (claim-reward (amount uint))
  (let ((user tx-sender))
    (asserts! (<= amount MAX_REWARD_AMOUNT) ERR_INVALID_AMOUNT)
    (asserts! (not (default-to false (map-get? claimed-rewards user))) ERR_ALREADY_CLAIMED)
    (asserts! (<= amount (var-get reward-pool)) ERR_INSUFFICIENT_BALANCE)
    
    (map-set user-rewards user amount)
    (map-set claimed-rewards user true)
    (var-set reward-pool (- (var-get reward-pool) amount))
    (var-set total-rewards-distributed (+ (var-get total-rewards-distributed) amount))
    
    (ok amount)
  )
)

;; Read-only functions
(define-read-only (get-reward-pool)
  (var-get reward-pool)
)

(define-read-only (get-user-reward (user principal))
  (default-to u0 (map-get? user-rewards user))
)

(define-read-only (has-claimed (user principal))
  (default-to false (map-get? claimed-rewards user))
)

(define-read-only (get-total-distributed)
  (var-get total-rewards-distributed)
)