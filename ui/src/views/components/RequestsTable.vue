<template>
  <div class="card mb-4">
    <div class="card-header pb-0">
      <h6>Blind Loan Requests</h6>
    </div>
    <div class="card-body px-0 pt-0 pb-2">
      <div class="table-responsive p-0">
        <table class="table align-items-center mb-0">
          <thead>
            <tr>
              <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Borrower</th>
              <th
                class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2"
              >Blind Deed Summary</th>
              <th
                class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
              >Valuation Status</th>
              <th
                class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
              >Blind Deed Composition</th>
              <th  class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Loan Requested</th>
              <th class="text-secondary opacity-7"></th>
            </tr>
          </thead>
          <tbody>       
            <tr>
              <td>               
                <div class="d-flex px-2 py-1">
                  <div>
                    <vsud-avatar :img="img1" size="sm" border-radius="lg" class="me-3" alt="user2" />
                  </div>
                  <div class="d-flex flex-column justify-content-center">
                    <p class="text-xs font-weight-bold mb-0">max.eth</p>
                    <p class="text-xs text-secondary mb-0">0x...6780</p>
                  </div>
                </div>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0">High value mix</p>
                <p class="text-xs text-secondary mb-0">Mix of my NFTs from various collection including BAYC, Pudgy Penguins etc.</p>
              </td>
              <td class="align-middle text-center text-sm">
                <vsud-badge color="success" variant="gradient" size="sm">Fresh</vsud-badge>
              </td>
              <td class="align-middle text-center">
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC721 : <b>100%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC20 : <b>0%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC1155 : <b>0%</b></span></p>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0"> <span class="text-xs font-weight-bold mb-0"">536</span></p>
                <p class="text-xs font-weight-bold mb-0"> <span class="text-secondary text-xs font-weight-bold">ETH</span></p>
                <p class="text-xs font-weight-bold mb-0"> <span class="text-secondary text-xs font-weight-bold">$1,500,000 (Current Equivalent USD)</span></p>
              </td> 
              <td class="align-middle">
                <a
                  href="javascript:;"
                  class="text-secondary font-weight-bold text-xs"
                  data-toggle="tooltip"
                  data-original-title="Make Offer"
                >Make Offer</a>
              </td>
            </tr>
            <tr>
              <td>
               
                <div class="d-flex px-2 py-1">
                  <div>
                    <vsud-avatar :img="img2" size="sm" border-radius="lg" class="me-3" alt="user2" />
                  </div>
                  <div class="d-flex flex-column justify-content-center">
                    <p class="text-xs font-weight-bold mb-0">max.eth</p>
                    <p class="text-xs text-secondary mb-0">0x...6780</p>
                  </div>
                </div>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0">High value mix</p>
                <p class="text-xs text-secondary mb-0">Mix of my NFTs from various collection including BAYC, Pudgy Penguins etc.</p>
              </td>
              <td class="align-middle text-center text-sm">
                <vsud-badge color="success" variant="gradient" size="sm">Fresh</vsud-badge>
              </td>
              <td class="align-middle text-center">
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC721 : <b>100%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC20 : <b>0%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC1155 : <b>0%</b></span></p>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">536<</span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ETH</span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">$1,500,000 (Current Equivalent USD)</span></p>
              </td> 
              <td class="align-middle">
                <a
                  href="javascript:;"
                  class="text-secondary font-weight-bold text-xs"
                  data-toggle="tooltip"
                  data-original-title="Make Offer"
                >Make Offer</a>
              </td>
            </tr>
            <tr>
              <td>
               
                <div class="d-flex px-2 py-1">
                  <div>
                    <vsud-avatar :img="img3" size="sm" border-radius="lg" class="me-3" alt="user2" />
                  </div>
                  <div class="d-flex flex-column justify-content-center">
                    <p class="text-xs font-weight-bold mb-0">max.eth</p>
                    <p class="text-xs text-secondary mb-0">0x...6780</p>
                  </div>
                </div>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0">High value mix</p>
                <p class="text-xs text-secondary mb-0">Mix of my NFTs from various collection including BAYC, Pudgy Penguins etc.</p>
              </td>
              <td class="align-middle text-center text-sm">
                <vsud-badge color="success" variant="gradient" size="sm">Fresh</vsud-badge>
              </td>
              <td class="align-middle text-center">
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC721 : <b>100%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC20 : <b>0%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC1155 : <b>0%</b></span></p>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">536</span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ETH</span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">$1,500,000 (Current Equivalent USD)</span></p>
              </td> 
              <td class="align-middle">
                <a
                  href="javascript:;"
                  class="text-secondary font-weight-bold text-xs"
                  data-toggle="tooltip"
                  data-original-title="Make Offer"
                >Make Offer</a>
              </td>
            </tr>
            <tr>
              <td>
               
                <div class="d-flex px-2 py-1">
                  <div>
                    <vsud-avatar :img="img4" size="sm" border-radius="lg" class="me-3" alt="user2" />
                  </div>
                  <div class="d-flex flex-column justify-content-center">
                    <p class="text-xs font-weight-bold mb-0">max.eth</p>
                    <p class="text-xs text-secondary mb-0">0x...6780</p>
                  </div>
                </div>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0">High value mix</p>
                <p class="text-xs text-secondary mb-0">Mix of my NFTs from various collection including BAYC, Pudgy Penguins etc.</p>
              </td>
              <td class="align-middle text-center text-sm">
                <vsud-badge color="success" variant="gradient" size="sm">Fresh</vsud-badge>
              </td>
              <td class="align-middle text-center">
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC721 : <b>100%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC20 : <b>0%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC1155 : <b>0%</b></span></p>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">536</span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ETH</span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">$1,500,000 (Current Equivalent USD)</span></p>
              </td> 
              <td class="align-middle">
                <a
                  href="javascript:;"
                  class="text-secondary font-weight-bold text-xs"
                  data-toggle="tooltip"
                  data-original-title="Make Offer"
                >Make Offer</a>
              </td>
            </tr>
            <tr>
              <td>
               
                <div class="d-flex px-2 py-1">
                  <div>
                    <vsud-avatar :img="img5" size="sm" border-radius="lg" class="me-3" alt="user2" />
                  </div>
                  <div class="d-flex flex-column justify-content-center">
                    <p class="text-xs font-weight-bold mb-0">max.eth</p>
                    <p class="text-xs text-secondary mb-0">0x...6780</p>
                  </div>
                </div>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0">High value mix</p>
                <p class="text-xs text-secondary mb-0">Mix of my NFTs from various collection including BAYC, Pudgy Penguins etc.</p>
              </td>
              <td class="align-middle text-center text-sm">
                <vsud-badge color="success" variant="gradient" size="sm">Fresh</vsud-badge>
              </td>
              <td class="align-middle text-center">
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC721 : <b>100%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC20 : <b>0%</b></span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ERC1155 : <b>0%</b></span></p>
              </td>
              <td>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">536</span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">ETH</span></p>
                <p class="text-xs font-weight-bold mb-0"><span class="text-secondary text-xs font-weight-bold">$1,500,000 (Current Equivalent USD)</span></p>
              </td> 
              <td class="align-middle">
                <a
                  href="javascript:;"
                  class="text-secondary font-weight-bold text-xs"
                  data-toggle="tooltip"
                  data-original-title="Make Offer"
                >Make Offer</a>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import VsudAvatar from "@/components/VsudAvatar.vue";
import VsudBadge from "@/components/VsudBadge.vue";
import img1 from "../../assets/img/team-2.jpg";
import img2 from "../../assets/img/team-3.jpg";
import img3 from "../../assets/img/team-4.jpg";
import img4 from "../../assets/img/team-3.jpg";
import img5 from "../../assets/img/team-2.jpg";
import img6 from "../../assets/img/team-4.jpg";

export default {
  name: "RequestsTable",
  components: {
    VsudAvatar,
    VsudBadge,
  },
  data() {
    return {
      img1,
      img2,
      img3,
      img4,
      img5,
      img6,
    };
  },
};
</script>